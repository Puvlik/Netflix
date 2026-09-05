import Foundation

typealias AppCoreDataServices = CoreDataServiceProtocol
& CoreDataGarbageCollectorProtocol
& CoreDataCacheClearingProtocol
& FavoriteMoviesCounterProtocol

// MARK: - CoreDataServiceProtocol
protocol CoreDataServiceProtocol {
    func searchLocalMovies(query: String) async throws -> [MovieModel]
    func fetchComingSoonMoviesFromDatabase() async throws -> [MovieModel]
    func fetchPopularMoviesFromDatabase() async throws -> [MovieModel]
    func fetchFavoriteMovie(id: Int) async throws -> MovieModel?
    func fetchAllFavoriteMovies() async throws -> [MovieModel]
    func updateMovie(_ movie: MovieModel) async throws
    func updateMoviesArray(_ movies: [MovieModel], isComingSoon: Bool, isPopular: Bool) async throws
    func setFavoriteState(to isFavorite: Bool, for movieId: Int) async throws
    func isMovieFavorite(id: Int) async throws -> Bool
}

// MARK: - FavoriteMoviesCounterProtocol
protocol FavoriteMoviesCounterProtocol {
    func getFavoriteMoviesCount() async throws -> Int
}

// MARK: - CoreDataGarbageCollectorProtocol
protocol CoreDataGarbageCollectorProtocol {
    func runGarbageCollector() async
}

// MARK: - CoreDataCacheClearingProtocol
protocol CoreDataCacheClearingProtocol {
    func clearLocalCache() async throws
    func getFavoriteMovieImagePaths() async throws -> Set<String>
}
