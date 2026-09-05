import Foundation
import Observation

// MARK: - HomeTabViewModel
@MainActor
@Observable
final class HomeTabViewModel {
    var isFeaturedMovieFavorite = false
    var isLoading = false
    var isLoadingMorePages = false
    var isLikeButtonLoading = false
    var showFetchFailedAlert = false
    var fetchFailedErrorMessage: String?
    var showPopularMoviesFetchFailedAlert = false
    var popularMoviesFetchFailedErrorMessage: String?
    var showCoreDataAlert = false
    var coreDataActiveError: CoreDataError?
    var onProfileTap: (() -> Void)?
    var showMovieDetails: ((_ movieId: Int) -> Void)?
        
    private var lastFailedPage: Int?
    private var currentPage = Constants.startPage
    private var moviesTotalPages = Constants.startPage
    private var featuredMovie: MovieModel?
    private var popularMovies = [MovieModel]()
    private let moviesService: MoviesServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    
    var isMoviesFetchFailed: Bool {
        fetchFailedErrorMessage != nil
    }
    
    var showLoaderWhenDataLoading: Bool {
        featuredMovie == nil && !isMoviesFetchFailed
    }
    
    var tempFeaturedMovie: MovieModel? {
        featuredMovie
    }
    
    var tempPopularMovies: [MovieModel] {
        popularMovies
    }
    
    var canLoadMorePages: Bool {
        currentPage < moviesTotalPages && !isLoadingMorePages
    }
    
    init(moviesService: MoviesServiceProtocol, coreDataService: CoreDataServiceProtocol) {
        self.moviesService = moviesService
        self.coreDataService = coreDataService
    }
    
    func openProfilePageTapped() {
        onProfileTap?()
    }
    
    func openMovieDetails(for movieId: Int) {
        showMovieDetails?(movieId)
    }
    
    func fetchPopularMovies(isPaginating: Bool = false) {
        guard shouldFetch(isPaginating: isPaginating) else { return }
        
        if isPaginating {
            isLoadingMorePages = true
        } else {
            isLoading = true
        }

        Task {
            await performFetch(isPaginating: isPaginating)
        }
    }
    
    func retryFetchPopularMovies() {
        lastFailedPage = nil
        fetchPopularMovies(isPaginating: true)
    }
    
    private func shouldFetch(isPaginating: Bool) -> Bool {
        if isPaginating {
            return canLoadMorePages
        }
        
        return !isLoading && popularMovies.isEmpty && featuredMovie == nil
    }

    private func performFetch(isPaginating: Bool) async {
        defer {
            if isPaginating {
                isLoadingMorePages = false
            } else {
                isLoading = false
            }
        }
        let cacheError = await prepareLoadingStateAndCache(isPaginating: isPaginating)
        let targetPage = isPaginating ? currentPage + 1 : Constants.startPage
        await fetchAndProcessNetworkMovies(
            targetPage: targetPage,
            isPaginating: isPaginating,
            cacheError: cacheError
        )
    }
    
    private func handleResult(_ movies: [MovieModel], isPaginating: Bool) -> [MovieModel] {
        if isPaginating {
            appendPage(with: movies)
        } else {
            setInitial(movies)
        }
    }

    private func appendPage(with movies: [MovieModel]) -> [MovieModel] {
        var existingIDs = Set(popularMovies.map(\.id))
        if let featured = featuredMovie {
            existingIDs.insert(featured.id)
        }
        
        let newMovies = movies.filter { !existingIDs.contains($0.id) }
        popularMovies.append(contentsOf: newMovies)
        return newMovies
    }

    private func setInitial(_ movies: [MovieModel]) -> [MovieModel] {
        guard !movies.isEmpty else {
            if featuredMovie == nil {
                fetchFailedErrorMessage = Strings.HomeTab.moviesUnavailableErrorText
                showFetchFailedAlert = true
            }
            return []
        }
        
        var tempMovies = movies
        featuredMovie = tempMovies.removeFirst()
        popularMovies = tempMovies
        refreshFeaturedMovieFavoriteState()
        return movies
    }
}

// MARK: - Core Data methods
extension HomeTabViewModel {
    func refreshFeaturedMovieFavoriteState() {
        guard let movie = featuredMovie else { return }
        
        Task {
            do {
                isFeaturedMovieFavorite = try await coreDataService.isMovieFavorite(id: movie.id)
            } catch {
                coreDataActiveError = .isFavoriteStatusCheckFailed
                showCoreDataAlert = true
            }
        }
    }
    
    func toggleFeaturedMovieFavoriteState() {
        guard let movie = featuredMovie, !isLikeButtonLoading else { return }
        let targetState = !isFeaturedMovieFavorite
        isLikeButtonLoading = true
        
        Task { [weak self] in
            guard let self else { return }
            defer {
                isLikeButtonLoading = false
            }

            do {
                try await coreDataService.setFavoriteState(to: targetState, for: movie.id)
                isFeaturedMovieFavorite = targetState
            } catch let error as CoreDataError {
                coreDataActiveError = error
                showCoreDataAlert = true
            }
        }
    }
}

// MARK: - Movies Fetch Method Helpers
private extension HomeTabViewModel {
    func prepareLoadingStateAndCache(isPaginating: Bool) async -> CoreDataError? {
        guard !isPaginating else {
            isLoadingMorePages = true
            return nil
        }
        
        do {
            let cachedMovies = try await coreDataService.fetchPopularMoviesFromDatabase()
            if !cachedMovies.isEmpty {
                _ = setInitial(cachedMovies)
                isLoading = false
            } else {
                isLoading = true
            }
            return nil
        } catch let error as CoreDataError {
            isLoading = true
            return error
        } catch {
            isLoading = true
            return nil
        }
    }
    
    func fetchAndProcessNetworkMovies(
        targetPage: Int,
        isPaginating: Bool,
        cacheError: CoreDataError?
    ) async {
        do {
            let response = try await moviesService.fetchPopularMovies(page: targetPage)
            lastFailedPage = nil
            moviesTotalPages = response.totalPages
            currentPage = targetPage
            
            let todayDateString = Date().convertToTMDBTypeString()
            let validMovies = response.movies.filter { $0.isPosterURLValid }
            let validReleasedMovies = validMovies
                .filter {
                    guard let releaseDate = $0.releaseDate else { return false }
                    return !releaseDate.isEmpty && releaseDate <= todayDateString
                }
                .sorted { firstMovie, secondMovie in
                    let firstPopularity = firstMovie.popularity ?? .zero
                    let secondPopularity = secondMovie.popularity ?? .zero
                    
                    if firstPopularity == secondPopularity {
                        return firstMovie.id < secondMovie.id
                    }
                    
                    return firstPopularity > secondPopularity
                }

            let moviesToCache = handleResult(validReleasedMovies, isPaginating: isPaginating)
            let coreDataService = self.coreDataService
            Task.detached(priority: .utility) {
                try? await coreDataService.updateMoviesArray(moviesToCache, isPopular: true)
            }
        } catch is CancellationError {

        } catch {
            handleNetworkError(
                error,
                isPaginating: isPaginating,
                targetPage: targetPage,
                cacheError: cacheError
            )
        }
    }
    
    func handleNetworkError(
        _ error: Error,
        isPaginating: Bool,
        targetPage: Int,
        cacheError: CoreDataError?
    ) {
        guard featuredMovie == nil else { return }
        if let actualDbError = cacheError {
            coreDataActiveError = actualDbError
            showCoreDataAlert = true
            return
        }

        if isPaginating {
            guard lastFailedPage != targetPage else { return }
            popularMoviesFetchFailedErrorMessage = error.localizedDescription
            showPopularMoviesFetchFailedAlert = true
            lastFailedPage = targetPage
            return
        }

        fetchFailedErrorMessage = error.localizedDescription
        showFetchFailedAlert = true
    }
}

// MARK: - Reset After Cache Cleared
extension HomeTabViewModel {
    func resetDataAfterCacheCleared() {
        featuredMovie = nil
        popularMovies.removeAll()
        currentPage = Constants.startPage
        lastFailedPage = nil
    }
}

// MARK: - Constants
private extension HomeTabViewModel {
    enum Constants {
        static var startPage: Int = 1
    }
}
