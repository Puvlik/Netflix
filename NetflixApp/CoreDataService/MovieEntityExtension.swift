import CoreData
import Foundation

protocol IdentifiableEntity: NSManagedObject {
    var id: Int64 { get }
}

extension GenreEntity: IdentifiableEntity {}

extension MovieEntity: IdentifiableEntity {
    func update(with movie: MovieModel) {
        self.id = Int64(movie.id)
        self.title = movie.title
        self.originalName = movie.originalName
        self.releaseDate = movie.releaseDate
        self.overview = movie.overview
        self.posterPath = movie.posterPath
        self.backdropPath = movie.backdropPath
        self.isAdult = movie.isAdult
        
        if let runtime = movie.runtime {
            self.runtime = Int64(runtime)
        }
        
        if let rating = movie.voteAverage {
            self.voteAverage = rating
        }
        
        if let popularity = movie.popularity {
            self.popularity = popularity
        }
    }
    
    func mapToMovieModel() -> MovieModel {
        MovieModel(
            id: Int(self.id),
            title: self.title,
            originalName: self.originalName,
            runtime: Int(self.runtime),
            voteAverage: self.voteAverage,
            popularity: self.popularity,
            releaseDate: self.releaseDate,
            overview: self.overview,
            posterPath: self.posterPath,
            backdropPath: self.backdropPath,
            isAdult: self.isAdult,
            genres: mappedGenres,
            genreIds: nil,
            recommendations: mappedRecommendations
        )
    }
    
    private var mappedGenres: [MovieGenre]? {
        guard let genreEntities = self.genres as? Set<GenreEntity>, !genreEntities.isEmpty else { return nil }
        return genreEntities.map { genreEntity in
            MovieGenre(id: Int(genreEntity.id), name: genreEntity.name ?? Strings.Common.emptyString)
        }
    }
    
    private var mappedRecommendations: MovieResponse? {
        guard let movieEntities = self.recommendations,
              !movieEntities.isEmpty,
              let resultsArray = movieEntities.array as? [MovieEntity] else { return nil }

        let results = resultsArray.map { MovieModel(entity: $0) }
        return MovieResponse(results: results, totalPages: nil)
    }
}
