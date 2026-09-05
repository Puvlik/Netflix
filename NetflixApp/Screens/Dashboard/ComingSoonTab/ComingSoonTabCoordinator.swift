import SwiftUI

// MARK: - ComingSoonTabCoordinator
final class ComingSoonTabCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    private let coreDataService: CoreDataServiceProtocol
    private let imageLoader: ImageLoadingProtocol
    private let networkMonitor: NetworkMonitorService
    private var viewModel: ComingSoonTabViewModel?
    
    init(
        navigationController: UINavigationController,
        coreDataService: CoreDataServiceProtocol,
        imageLoader: ImageLoadingProtocol,
        networkMonitor: NetworkMonitorService
    ) {
        self.navigationController = navigationController
        self.coreDataService = coreDataService
        self.imageLoader = imageLoader
        self.networkMonitor = networkMonitor
    }
    
    func start() {
        let networkService = NetworkService()
        let moviesService = MoviesService(networkService: networkService)
        let viewModel = ComingSoonTabViewModel(moviesService: moviesService, coreDataService: coreDataService)
        self.viewModel = viewModel
        viewModel.showMovieDetails = { [weak self] movieId in
            guard let self else { return }
            self.movieDetailsDidStarted(for: movieId)
        }
        
        let comingSoonTabView = ComingSoonTabView(viewModel: viewModel)
            .environment(networkMonitor)
        let hostingController = UIHostingController(
            rootView: comingSoonTabView.environment(\.imageLoader, self.imageLoader)
        )
        navigationController.setViewControllers([hostingController], animated: false)
    }
}

// MARK: - MovieDetails Delegate
extension ComingSoonTabCoordinator: MovieDetailsCoordinatorDelegate {
    func movieDetailsDidStarted(for id: Int) {
        let movieCoordinator = MovieDetailsCoordinator(
            navigationController: navigationController,
            coreDataService: coreDataService,
            imageLoader: imageLoader,
            networkMonitor: networkMonitor,
            movieId: id
        )
        
        movieCoordinator.delegate = self
        addChildCoordinator(movieCoordinator)
        movieCoordinator.start()
    }
    
    func movieDetailsDidFinish(_ coordinator: MovieDetailsCoordinator) {
        self.navigationController.popViewController(animated: true)
        removeChildCoordinator(coordinator)
    }
}

// MARK: - CacheRefreshableDelegate
extension ComingSoonTabCoordinator: CacheRefreshableDelegate {
    func refreshAfterCacheCleared() {
        viewModel?.resetDataAfterCacheCleared()
    }
}
