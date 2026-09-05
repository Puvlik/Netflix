import SwiftUI

// MARK: - HomeTabCoordinatorDelegate
protocol HomeTabCoordinatorDelegate: AnyObject {
    func homeTabDidFinish(_ coordinator: HomeTabCoordinator)
}

// MARK: - HomeTabCoordinator
final class HomeTabCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    weak var delegate: HomeTabCoordinatorDelegate?
    weak var cacheDelegate: CacheClearingDelegate?
    private let coreDataService: AppCoreDataServices
    private let imageCache: ImageCachingProtocol
    private let imageLoader: ImageLoadingProtocol
    private let networkMonitor: NetworkMonitorService
    private var viewModel: HomeTabViewModel?
    
    init(
        navigationController: UINavigationController,
        coreDataService: AppCoreDataServices,
        imageCache: ImageCachingProtocol,
        imageLoader: ImageLoadingProtocol,
        networkMonitor: NetworkMonitorService
    ) {
        self.navigationController = navigationController
        self.coreDataService = coreDataService
        self.imageCache = imageCache
        self.imageLoader = imageLoader
        self.networkMonitor = networkMonitor
    }
    
    func start() {
        let networkService = NetworkService()
        let moviesService = MoviesService(networkService: networkService)
        let viewModel = HomeTabViewModel(moviesService: moviesService, coreDataService: coreDataService)
        self.viewModel = viewModel
        viewModel.onProfileTap = { [weak self] in
            guard let self else { return }
            self.profileDidStarted()
        }
        
        viewModel.showMovieDetails = { [weak self] movieId in
            guard let self else { return }
            self.movieDetailsDidStarted(for: movieId)
        }
        
        let homeTabView = HomeTabView(viewModel: viewModel)
            .environment(networkMonitor)
        let hostingController = UIHostingController(
            rootView: homeTabView.environment(\.imageLoader, self.imageLoader)
        )
        navigationController.setViewControllers([hostingController], animated: false)
    }
}

// MARK: - MovieDetailsCoordinatorDelegate
extension HomeTabCoordinator: MovieDetailsCoordinatorDelegate {
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

// MARK: - ProfileCoordinatorDelegate
extension HomeTabCoordinator: ProfileCoordinatorDelegate {
    func profileDidStarted() {
        let profileCoordinator = ProfileCoordinator(
            navigationController: navigationController,
            coreDataService: coreDataService,
            imageCache: imageCache,
            networkMonitor: networkMonitor
        )
        profileCoordinator.delegate = self
        profileCoordinator.cacheDelegate = self
        addChildCoordinator(profileCoordinator)
        profileCoordinator.start()
    }
    
    func profileDidClosed(_ coordinator: ProfileCoordinator) {
        self.navigationController.popViewController(animated: true)
        removeChildCoordinator(coordinator)
    }
    
    func profileDidLogout(_ coordinator: ProfileCoordinator) {
        removeAllChildCoordinators()
        self.delegate?.homeTabDidFinish(self)
    }
}

// MARK: - CacheRefreshableDelegate
extension HomeTabCoordinator: CacheRefreshableDelegate {
    func refreshAfterCacheCleared() {
        viewModel?.resetDataAfterCacheCleared()
    }
}

// MARK: - CacheClearingDelegate
extension HomeTabCoordinator: CacheClearingDelegate {
    func didClearLocalCache() {
        cacheDelegate?.didClearLocalCache()
    }
}
