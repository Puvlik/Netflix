import CoreData
import Foundation
import os

// MARK: - CoreDataService
final class CoreDataService: CoreDataServiceProtocol {
    let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func updateMovie(_ movie: MovieModel) async throws {
        try await updateMoviesArray([movie])
    }
    
    func updateMoviesArray(_ movies: [MovieModel], isComingSoon: Bool, isPopular: Bool) async throws {
        guard !movies.isEmpty else { return }
        try await container.performBackgroundTask { context in
            let (movieIDs, genreIDs) = self.extractIDs(from: movies)
            var moviesDictionary: [Int: MovieEntity] = self.fetchEntities(by: movieIDs, in: context)
            var genreDictionary: [Int: GenreEntity] = self.fetchEntities(by: genreIDs, in: context)
            self.processMovies(
                movies,
                isComingSoon: isComingSoon,
                isPopular: isPopular,
                context: context,
                moviesDictionary: &moviesDictionary,
                genreDictionary: &genreDictionary
            )
            
            guard context.hasChanges else { return }
            
            do {
                try context.save()
            } catch {
                AppLogger.coreData.error("Save failed in updateMoviesArray: \(error.localizedDescription)")
                throw CoreDataError.addToCoreDataFailed
            }
        }
    }
    
    func fetchAllFavoriteMovies() async throws -> [MovieModel] {
        try await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isFavorite == YES")
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "addedToFavoritesAt", ascending: false)
            ]
            
            do {
                return try context.fetch(fetchRequest).map { $0.mapToMovieModel() }
            } catch {
                throw CoreDataError.moviesFetchFailed
            }
        }
    }
    
    func fetchFavoriteMovie(id: Int) async throws -> MovieModel? {
        try await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.fetchLimit = 1
            
            do {
                return try context.fetch(fetchRequest).first?.mapToMovieModel()
            } catch {
                throw CoreDataError.favoriteMovieFetchFailed
            }
        }
    }
    
    func setFavoriteState(to isFavorite: Bool, for movieId: Int) async throws {
        try await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)
            fetchRequest.fetchLimit = 1
            
            let entity: MovieEntity
            if let existingEntity = try? context.fetch(fetchRequest).first {
                entity = existingEntity
            } else {
                entity = MovieEntity(context: context)
                entity.id = Int64(movieId)
            }
            
            entity.isFavorite = isFavorite
            entity.addedToFavoritesAt = isFavorite ? Date() : nil
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    throw isFavorite ? CoreDataError.addToFavoritesFailed : CoreDataError.removeFromFavoritesFailed
                }
            }
        }
    }
    
    func isMovieFavorite(id: Int) async throws -> Bool {
        try await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.fetchLimit = 1
            fetchRequest.propertiesToFetch = ["isFavorite"]
            
            do {
                guard let movie = try context.fetch(fetchRequest).first else {
                    return false
                }
                return movie.isFavorite
            } catch {
                throw CoreDataError.isFavoriteStatusCheckFailed
            }
        }
    }
}

private extension CoreDataService {
    func processGenres(
        for entity: MovieEntity,
        from movie: MovieModel,
        in context: NSManagedObjectContext,
        genreDictionary: inout [Int: GenreEntity]
    ) {
        guard let genres = movie.genres, !genres.isEmpty else { return }
        genres.forEach { genre in
            let genreEntity = genreDictionary[genre.id] ?? {
                let newGenre = GenreEntity(context: context)
                newGenre.id = Int64(genre.id)
                genreDictionary[genre.id] = newGenre
                return newGenre
            }()
            
            genreEntity.name = genre.name
            entity.addToGenres(genreEntity)
        }
    }
    
    func processRecommendations(
        for entity: MovieEntity,
        from movie: MovieModel,
        in context: NSManagedObjectContext,
        recommendationsDictionary: inout [Int: MovieEntity]
    ) {
        guard let recommendations = movie.recommendations?.results, !recommendations.isEmpty else { return }
        recommendations.forEach { recommendation in
            let relatedEntity = recommendationsDictionary[recommendation.id] ?? {
                let newEntity = MovieEntity(context: context)
                newEntity.id = Int64(recommendation.id)
                recommendationsDictionary[recommendation.id] = newEntity
                return newEntity
            }()
            relatedEntity.update(with: recommendation)
            entity.addToRecommendations(relatedEntity)
        }
    }

    func fetchEntities<T: IdentifiableEntity>(by ids: Set<Int>, in context: NSManagedObjectContext ) -> [Int: T] {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = NSPredicate(format: "id IN %@", ids)
        let fetched = (try? context.fetch(request)) ?? []
        return fetched.reduce(into: [:]) { $0[Int($1.id)] = $1 }
    }
    
    func extractIDs(from movies: [MovieModel]) -> (movieIDs: Set<Int>, genreIDs: Set<Int>) {
        var allMovieIDs = Set<Int>()
        var allGenreIDs = Set<Int>()
        
        movies.forEach { movie in
            allMovieIDs.insert(movie.id)
            movie.recommendations?.results.forEach { allMovieIDs.insert($0.id) }
            movie.genres?.forEach { allGenreIDs.insert($0.id) }
        }
        
        return (allMovieIDs, allGenreIDs)
    }
    
    private func processMovies(
        _ movies: [MovieModel],
        isComingSoon: Bool,
        isPopular: Bool,
        context: NSManagedObjectContext,
        moviesDictionary: inout [Int: MovieEntity],
        genreDictionary: inout [Int: GenreEntity]
    ) {
        movies.forEach { movie in
            let entity = getOrCreateMovieEntity(for: movie.id, in: context, dictionary: &moviesDictionary)
            updateMovieFlags(entity, with: movie, isComingSoon: isComingSoon, isPopular: isPopular)
            processGenres(for: entity, from: movie, in: context, genreDictionary: &genreDictionary)
            processRecommendations(for: entity, from: movie, in: context, recommendationsDictionary: &moviesDictionary)
        }
    }
    
    func getOrCreateMovieEntity(
        for id: Int,
        in context: NSManagedObjectContext,
        dictionary: inout [Int: MovieEntity]
    ) -> MovieEntity {
        if let existingEntity = dictionary[id] {
            return existingEntity
        }
        
        let newEntity = MovieEntity(context: context)
        newEntity.id = Int64(id)
        dictionary[id] = newEntity
        return newEntity
    }

    func updateMovieFlags(
        _ entity: MovieEntity,
        with movie: MovieModel,
        isComingSoon: Bool,
        isPopular: Bool
    ) {
        let currentFavorite = entity.isFavorite
        let currentComingSoon = entity.isComingSoon
        let currentPopular = entity.isPopular
        entity.update(with: movie)
        entity.isFavorite = currentFavorite
        entity.isComingSoon = isComingSoon || currentComingSoon
        entity.isPopular = isPopular || currentPopular
    }
}

// MARK: - Offline methods
extension CoreDataService {
    func searchLocalMovies(query: String) async throws -> [MovieModel] {
        try await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "title CONTAINS[cd] %@ OR originalName CONTAINS[cd] %@", query, query
            )
            fetchRequest.fetchLimit = 20
            
            do {
                return try context.fetch(fetchRequest).map { $0.mapToMovieModel() }
            } catch {
                throw CoreDataError.moviesFetchFailed
            }
        }
    }
    
    func fetchComingSoonMoviesFromDatabase() async throws -> [MovieModel] {
        try await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            let todayDateString = Date().convertToTMDBTypeString()
            fetchRequest.predicate = NSPredicate(format: "isComingSoon == YES AND releaseDate >= %@", todayDateString)
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "releaseDate", ascending: true),
                NSSortDescriptor(key: "id", ascending: true)
            ]

            do {
                return try context.fetch(fetchRequest).map { $0.mapToMovieModel() }
            } catch {
                throw CoreDataError.moviesFetchFailed
            }
        }
    }

    func fetchPopularMoviesFromDatabase() async throws -> [MovieModel] {
        try await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isPopular == YES")
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "popularity", ascending: false),
                NSSortDescriptor(key: "id", ascending: true)
            ]
            
            do {
                return try context.fetch(fetchRequest).map { $0.mapToMovieModel() }
            } catch {
                throw CoreDataError.moviesFetchFailed
            }
        }
    }
}

// MARK: - CoreDataServiceProtocol extension
extension CoreDataServiceProtocol {
    func updateMoviesArray(_ movies: [MovieModel]) async throws {
        try await updateMoviesArray(movies, isComingSoon: false, isPopular: false)
    }

    func updateMoviesArray(_ movies: [MovieModel], isComingSoon: Bool) async throws {
        try await updateMoviesArray(movies, isComingSoon: isComingSoon, isPopular: false)
    }

    func updateMoviesArray(_ movies: [MovieModel], isPopular: Bool) async throws {
        try await updateMoviesArray(movies, isComingSoon: false, isPopular: isPopular)
    }
}

extension CoreDataService: FavoriteMoviesCounterProtocol {
    func getFavoriteMoviesCount() async throws -> Int {
        try await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isFavorite == YES")

            do {
                return try context.count(for: fetchRequest)
            } catch {
                AppLogger.coreData.error("Count favorite movies failed: \(error.localizedDescription)")
                throw CoreDataError.moviesFetchFailed
            }
        }
    }
}
