import Foundation
import Observation
import os

// MARK: - ComingSoonTabViewModel
@MainActor
@Observable
final class ComingSoonTabViewModel {
    var isLoading = false
    var isLoadingMorePages = false
    var searchText = Strings.Common.emptyString
    var comingSoonErrorMessage: String?
    var showPaginationFetchFailedAlert = false
    var paginationErrorMessage: String?
    var showCoreDataAlert = false
    var coreDataActiveError: CoreDataError?
    var showMovieDetails: ((_ movieId: Int) -> Void)?

    private var lastFailedPage: Int?
    private var currentPage = Constants.startPage
    private var moviesTotalPages = Constants.startPage
    private var lastSearchedQuery = Strings.Common.emptyString
    private var comingSoonMovies = [MovieModel]()
    private var moviesSearchResult = [MovieModel]()
    private let moviesService: MoviesServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    
    var isMoviesFetchFailed: Bool {
        comingSoonErrorMessage != nil
    }
    
    var showLoaderWhenDataLoading: Bool {
        isLoading && !isMoviesFetchFailed
    }
    
    var tempMoviesArray: [MovieModel] {
        searchText.isEmpty ? comingSoonMovies : moviesSearchResult
    }
    
    var isMoviesSearchArrayEmpty: Bool {
        !isLoading && tempMoviesArray.isEmpty && !searchText.isEmpty
    }
    
    var canLoadMorePages: Bool {
        currentPage < moviesTotalPages && !isLoadingMorePages
    }
    
    init(moviesService: MoviesServiceProtocol, coreDataService: CoreDataServiceProtocol) {
        self.moviesService = moviesService
        self.coreDataService = coreDataService
    }
    
    func openMovieDetails(for movieId: Int) {
        showMovieDetails?(movieId)
    }
    
    func fetchComingSoonMovies() {
        guard !isLoading, comingSoonMovies.isEmpty else { return }
        
        Task {
            await performMoviesFetch(isSearching: false, isPaginating: false)
        }
    }
    
    func retryFailedFetch() {
        comingSoonErrorMessage = nil
        
        if searchText.isEmpty {
            fetchComingSoonMovies()
        } else {
            lastSearchedQuery = Strings.Common.emptyString
            Task {
                await performMoviesSearchWithQuery()
            }
        }
    }
    
    func performMoviesSearchWithQuery() async {
        comingSoonErrorMessage = nil
        
        guard !searchText.isEmpty else {
            moviesSearchResult = []
            lastSearchedQuery = Strings.Common.emptyString
            isLoading = false
            return
        }
        
        guard searchText != lastSearchedQuery else {
            return
        }
        
        lastSearchedQuery = searchText
        
        do {
            try await Task.sleep(for: .milliseconds(Constants.debounceDelay))
            try Task.checkCancellation()
            let cachedMovies = try await coreDataService.searchLocalMovies(query: searchText)
            moviesSearchResult = cachedMovies
            isLoading = cachedMovies.isEmpty
            await performMoviesFetch(isSearching: true, isPaginating: false)
        } catch is CancellationError {
            
        } catch let error {
            isLoading = false
            AppLogger.network.error(
                "Failed to search movies with query: \(self.searchText). Error: \(error.localizedDescription)"
            )
        }
    }

    func loadNextMoviePages() {
        guard canLoadMorePages, !isLoadingMorePages else { return }
        
        Task {
            await performMoviesFetch(isSearching: !searchText.isEmpty, isPaginating: true)
        }
    }
    
    func retryLoadNextMoviePages() {
        lastFailedPage = nil
        loadNextMoviePages()
    }
    
    private func performMoviesFetch(isSearching: Bool, isPaginating: Bool) async {
        let cacheError = await prepareInitialDataAndLoadingState(
            isSearching: isSearching,
            isPaginating: isPaginating
        )
        
        let targetPage = isPaginating ? currentPage + 1 : Constants.startPage
        await fetchAndCacheNetworkMovies(
            isSearching: isSearching,
            isPaginating: isPaginating,
            targetPage: targetPage,
            cacheError: cacheError
        )
        
        if isPaginating {
            isLoadingMorePages = false
        } else {
            isLoading = false
        }
    }
    
    private func fetchMovies(isSearching: Bool, page: Int) async throws -> PaginatedMovies {
        if isSearching {
            return try await moviesService.searchMovies(with: searchText, page: page)
        } else {
            return try await moviesService.fetchComingSoonMovies(page: page)
        }
    }
    
    private func handleFetchedMovies(_ movies: [MovieModel], isSearching: Bool, isPaginating: Bool) -> [MovieModel] {
        if isSearching {
            processSearchData(movies, isPaginating: isPaginating)
        } else {
            processComingSoonData(movies, isPaginating: isPaginating)
        }
    }
    
    private func processSearchData(_ movies: [MovieModel], isPaginating: Bool) -> [MovieModel] {
        if isPaginating {
            let existingIDs = Set(moviesSearchResult.map(\.id))
            let newUnique = movies.filter { !existingIDs.contains($0.id) }
            moviesSearchResult.append(contentsOf: newUnique)
            return newUnique
        } else {
            moviesSearchResult = movies
            return movies
        }
    }
    
    private func processComingSoonData(_ movies: [MovieModel], isPaginating: Bool) -> [MovieModel] {
        let todayDateString = Date().convertToTMDBTypeString()
        let validFutureMovies = movies.filter { movie in
            guard let releaseDate = movie.releaseDate else { return false }
            return !releaseDate.isEmpty && releaseDate >= todayDateString
        }

        if isPaginating {
            let existingIDs = Set(comingSoonMovies.map(\.id))
            let newUnique = validFutureMovies.filter { !existingIDs.contains($0.id) }
            let sortedNewUnique = newUnique.sorted {
                $0.releaseDate.convertToTMDBDate() < $1.releaseDate.convertToTMDBDate()
            }
            comingSoonMovies.append(contentsOf: sortedNewUnique)
            return newUnique
        } else {
            guard !validFutureMovies.isEmpty else {
                comingSoonErrorMessage = Strings.HomeTab.moviesUnavailableErrorText
                return []
            }
            
            comingSoonMovies = validFutureMovies.sorted { movie1, movie2 in
                let date1 = movie1.releaseDate.convertToTMDBDate()
                let date2 = movie2.releaseDate.convertToTMDBDate()
                
                if date1 == date2 {
                    return movie1.id < movie2.id
                }
                
                return date1 < date2
            }
            return comingSoonMovies
        }
    }
}

// MARK: - Movies Fetch Method Helpers
private extension ComingSoonTabViewModel {
    func prepareInitialDataAndLoadingState(isSearching: Bool, isPaginating: Bool) async -> CoreDataError? {
        guard !isPaginating else {
            isLoadingMorePages = true
            return nil
        }
        
        do {
            let cachedMovies = isSearching
                ? try await coreDataService.searchLocalMovies(query: searchText)
                : try await coreDataService.fetchComingSoonMoviesFromDatabase()
            
            if !cachedMovies.isEmpty {
                if isSearching {
                    moviesSearchResult = cachedMovies
                } else {
                    comingSoonMovies = cachedMovies
                }
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
    
    func fetchAndCacheNetworkMovies(
        isSearching: Bool,
        isPaginating: Bool,
        targetPage: Int,
        cacheError: CoreDataError?
    ) async {
        do {
            let response = try await fetchMovies(isSearching: isSearching, page: targetPage)
            lastFailedPage = nil
            moviesTotalPages = response.totalPages
            currentPage = targetPage
            
            let validMovies = response.movies.filter { $0.isPosterURLValid }
            let moviesToCache = handleFetchedMovies(
                validMovies,
                isSearching: isSearching,
                isPaginating: isPaginating
            )
            
            let coreDataService = self.coreDataService
            Task.detached(priority: .utility) {
                try? await coreDataService.updateMoviesArray(moviesToCache, isComingSoon: !isSearching)
            }
        } catch is CancellationError {

        } catch {
            handleNetworkError(
                error,
                isSearching: isSearching,
                isPaginating: isPaginating,
                targetPage: targetPage,
                cacheError: cacheError
            )
        }
    }
    
    func handleNetworkError(
        _ error: Error,
        isSearching: Bool,
        isPaginating: Bool,
        targetPage: Int,
        cacheError: CoreDataError?
    ) {
        let hasLocalData = isSearching ? !moviesSearchResult.isEmpty : !comingSoonMovies.isEmpty
        guard !hasLocalData else { return }
        if let actualDbError = cacheError {
            coreDataActiveError = actualDbError
            showCoreDataAlert = true
            return
        }
        
        if isSearching, let networkError = error as? NetworkManagerError, networkError == .offline {
            return
        }

        if isPaginating {
            guard lastFailedPage != targetPage else { return }
            paginationErrorMessage = error.localizedDescription
            showPaginationFetchFailedAlert = true
            lastFailedPage = targetPage
            return
        }

        comingSoonErrorMessage = error.localizedDescription
    }
}

// MARK: - Reset After Cache Cleared
extension ComingSoonTabViewModel {
    func resetDataAfterCacheCleared() {
        comingSoonMovies.removeAll()
        moviesSearchResult.removeAll()
        lastSearchedQuery = Strings.Common.emptyString
        currentPage = Constants.startPage
        lastFailedPage = nil
    }
}

// MARK: - Constants
private extension ComingSoonTabViewModel {
    enum Constants {
        static var debounceDelay: Double = 200
        static var startPage: Int = 1
    }
}
