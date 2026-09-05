import Foundation
import Observation

// MARK: - MovieDetailsViewModel
@MainActor
@Observable
final class MovieDetailsViewModel {
    var movie: MovieModel?
    var isMovieFavorite = false
    var isLoading = false
    var isLoadingMorePages = false
    var showCoreDataAlert = false
    var coreDataActiveError: CoreDataError?
    var showMovieDetailsFetchFailedAlert = false
    var showRelatedMoviesFetchFailedAlert = false
    var movieDetailsErrorMessage: String?
    var relatedMoviesErrorMessage: String?
    
    var onDismissTapped: (() -> Void)?
    var onRelatedMovieTap: ((_ movieId: Int) -> Void)?
    
    private var lastFailedPage: Int?
    private let movieId: Int
    private var currentPage = Constants.startPage
    private var recommendationsTotalPages = Constants.startPage
    private var recommendationMovies = [MovieModel]()
    
    private let moviesService: MoviesServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    
    init(moviesService: MoviesServiceProtocol, coreDataService: CoreDataServiceProtocol, id: Int) {
        self.moviesService = moviesService
        self.coreDataService = coreDataService
        self.movieId = id
    }
    
    var tempRecommendationsArray: [MovieModel] {
        recommendationMovies
    }
    
    var isMovieFetchFailed: Bool {
        movieDetailsErrorMessage != nil
    }
    
    var showLoaderWhenDataLoading: Bool {
        isLoading && movie == nil && !isMovieFetchFailed
    }
    
    var canLoadMorePages: Bool {
        currentPage < recommendationsTotalPages && !isLoadingMorePages
    }
    
    func fetchMovieDetails() {
        guard !isLoading && movie == nil else { return }
        
        isLoading = true
        
        Task {
            await performFetch(id: movieId)
        }
    }
    
    func loadNextRecommendationPages() {
        guard canLoadMorePages, !isLoadingMorePages else { return }
        
        isLoadingMorePages = true
        
        Task {
            await performRecommendationsFetch()
        }
    }
    
    func retryLoadNextRecommendationPages() {
        lastFailedPage = nil
        loadNextRecommendationPages()
    }

    private func performFetch(id: Int) async {
        let cacheError = await loadCachedMovie(id: id)
        isLoading = (movie == nil)
        await fetchNetworkMovie(id: id, cacheError: cacheError)
        isLoading = false
        refreshMovieFavoriteState()
    }
    
    private func performRecommendationsFetch() async {
        defer {
            isLoadingMorePages = false
        }
        
        let targetPage = currentPage + 1
        
        do {
            let response = try await moviesService.fetchMovieRecommendations(id: movieId, page: targetPage)
            lastFailedPage = nil
            recommendationsTotalPages = response.totalPages
            currentPage = targetPage

            let existingIDs = Set(recommendationMovies.map(\.id))
            let validMovies = response.movies.filter { $0.isBackdropURLValid }
            let newUniqueMovies = validMovies.filter { !existingIDs.contains($0.id) }
            recommendationMovies.append(contentsOf: newUniqueMovies)

            Task { [weak self] in
                guard let self = self, var currentMovie = self.movie else { return }
                currentMovie.recommendations = MovieResponse(
                    results: self.recommendationMovies,
                    totalPages: self.recommendationsTotalPages
                )

                self.movie = currentMovie
                try? await self.coreDataService.updateMovie(currentMovie)
            }
        } catch is CancellationError {

        } catch {
            if case .offline = error as? NetworkManagerError {
                recommendationsTotalPages = currentPage
            } else {
                if lastFailedPage != targetPage {
                    relatedMoviesErrorMessage = error.localizedDescription
                    showRelatedMoviesFetchFailedAlert = true
                    lastFailedPage = targetPage
                }
            }
        }
    }

    func openRelatedMovieDetails(id: Int) {
        onRelatedMovieTap?(id)
    }
    
    func closeMovieDetails() {
        onDismissTapped?()
    }
}

// MARK: - Favorite State Core Data Methods
extension MovieDetailsViewModel {
    func refreshMovieFavoriteState() {
        Task {
            do {
                isMovieFavorite = try await coreDataService.isMovieFavorite(id: movieId)
            } catch {
                coreDataActiveError = .isFavoriteStatusCheckFailed
                showCoreDataAlert = true
            }
        }
    }
    
    func toggleMovieFavoriteState() {
        guard let movie = movie else { return }
        isMovieFavorite.toggle()
        let targetState = isMovieFavorite
        
        Task { [weak self] in
            guard let self else { return }
            
            do {
                try await coreDataService.setFavoriteState(to: targetState, for: movie.id)
            } catch let error as CoreDataError {
                isMovieFavorite = !targetState
                coreDataActiveError = error
                showCoreDataAlert = true
            }
        }
    }
}

// MARK: - Movie Fetch Method Helpers
private extension MovieDetailsViewModel {
    func loadCachedMovie(id: Int) async -> CoreDataError? {
        do {
            if let cachedMovie = try await coreDataService.fetchFavoriteMovie(id: id) {
                movie = cachedMovie
                isLoading = false
                applyCacheRecommendations(cachedMovie.recommendations)
            }
            return nil
        } catch let error as CoreDataError {
            return error
        } catch {
            return nil
        }
    }
    
    func fetchNetworkMovie(id: Int, cacheError: CoreDataError?) async {
        do {
            let fetchedMovie = try await moviesService.fetchMovieDetails(id: id)
            movie = fetchedMovie
            applyNetworkRecommendations(fetchedMovie.recommendations)

            Task {
                try? await coreDataService.updateMovie(fetchedMovie)
            }
        } catch is CancellationError {

        } catch {
            handleFetchError(error, cacheError: cacheError)
        }
    }
    
    func applyCacheRecommendations(_ recommendations: MovieResponse?) {
        guard let recommendations = recommendations else { return }
        recommendationMovies = recommendations.results.filter { $0.isBackdropURLValid }
        recommendationsTotalPages = Constants.startPage
        currentPage = Constants.startPage
    }

    func applyNetworkRecommendations(_ recommendations: MovieResponse?) {
        guard let recommendations = recommendations else { return }
        recommendationMovies = recommendations.results.filter { $0.isBackdropURLValid }
        recommendationsTotalPages = recommendations.totalPages ?? Constants.startPage
        currentPage = Constants.startPage
    }

    func handleFetchError(_ networkError: Error, cacheError: CoreDataError?) {
        guard movie == nil else { return }
        
        if let actualError = cacheError {
            coreDataActiveError = actualError
            showCoreDataAlert = true
        } else {
            movieDetailsErrorMessage = networkError.localizedDescription
            showMovieDetailsFetchFailedAlert = true
        }
    }
}

// MARK: - Constants
private extension MovieDetailsViewModel {
    enum Constants {
        static var startPage: Int = 1
    }
}
