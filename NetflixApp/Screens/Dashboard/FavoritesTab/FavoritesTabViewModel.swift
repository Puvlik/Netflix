import Foundation

// MARK: - FavoritesViewState
enum FavoritesViewState {
    case loading
    case loaded
    case fetchErrorAlert
    case fetchFailedView
}

// MARK: - FavoritesTabViewModel
@MainActor
@Observable
final class FavoritesTabViewModel {
    var favoriteMovies = [MovieModel]()
    var viewState: FavoritesViewState = .loading
    var showCoreDataAlert = false
    var coreDataActiveError: CoreDataError?
    var showMovieDetails: ((_ movieId: Int) -> Void)?
    var discoverMoviesTapped: (() -> Void)?
    var movieToRestore: (movie: MovieModel, index: Int)?
    private let coreDataService: CoreDataServiceProtocol
    
    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }

    func openMovieDetails(for movieId: Int) {
        showMovieDetails?(movieId)
    }
    
    func openComingSoonToDiscoverMovies() {
        discoverMoviesTapped?()
    }
    
    func fetchFavoriteMovies() {
        viewState = .loading
        
        Task {
            do {
                let favoriteMovies = try await coreDataService.fetchAllFavoriteMovies()
                self.favoriteMovies = favoriteMovies
                viewState = .loaded
            } catch {
                coreDataActiveError = .moviesFetchFailed
                showCoreDataAlert = true
                viewState = .fetchErrorAlert
            }
        }
    }
    
    func removeFromFavorites(movie: MovieModel) {
        guard let index = favoriteMovies.firstIndex(where: { $0.id == movie.id }) else { return }
        favoriteMovies.remove(at: index)

        Task {
            do {
                try await coreDataService.setFavoriteState(to: false, for: movie.id)
            } catch {
                movieToRestore = (movie, index)
                coreDataActiveError = .removeFromFavoritesFailed
                showCoreDataAlert = true
            }
        }
    }
}
