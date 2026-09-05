import Foundation

typealias PaginatedMovies = (movies: [MovieModel], totalPages: Int)

protocol MoviesServiceProtocol {
    func fetchPopularMovies(page: Int) async throws -> PaginatedMovies
    func fetchComingSoonMovies(page: Int) async throws -> PaginatedMovies
    func searchMovies(with query: String, page: Int) async throws -> PaginatedMovies
    func fetchMovieDetails(id: Int) async throws -> MovieModel
    func fetchMovieRecommendations(id: Int, page: Int) async throws -> PaginatedMovies
}

// MARK: - MoviesService
final class MoviesService: MoviesServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchPopularMovies(page: Int) async throws -> PaginatedMovies {
        try await fetchMovies(from: APIRouter.popularMovies(page: page))
    }
    
    func fetchComingSoonMovies(page: Int) async throws -> PaginatedMovies {
        try await fetchMovies(from: APIRouter.upcomingMovies(page: page))
    }
    
    func searchMovies(with query: String, page: Int) async throws -> PaginatedMovies {
        try await fetchMovies(from: APIRouter.searchMovies(query: query, page: page))
    }
    
    func fetchMovieDetails(id: Int) async throws -> MovieModel {
        try await networkService.performRequest(endpoint: APIRouter.movieDetails(id: id))
    }
    
    func fetchMovieRecommendations(id: Int, page: Int) async throws -> PaginatedMovies {
        let response: MovieResponse = try await networkService.performRequest(
            endpoint: APIRouter.movieRecommendations(id: id, page: page)
        )
        
        return (response.results, response.totalPages ?? Constants.defaultPage)
    }
    
    private func fetchMovies(from endpoint: Endpoint) async throws -> PaginatedMovies {
        let response: MovieResponse = try await networkService.performRequest(endpoint: endpoint)
        return (response.results, response.totalPages ?? Constants.defaultPage)
    }
}

private extension MoviesService {
    enum Constants {
        static let defaultPage: Int = 1
    }
}
