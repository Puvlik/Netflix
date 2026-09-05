import SwiftUI

protocol FavoritesTabCoordinatorDelegate: AnyObject {
    func navigateToComingSoonTab()
}

// MARK: - FavoritesTabCoordinator
final class FavoritesTabCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    weak var delegate: FavoritesTabCoordinatorDelegate?
    private let coreDataService: CoreDataServiceProtocol
    private let imageLoader: ImageLoadingProtocol
    private let networkMonitor: NetworkMonitorService
    
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
        let viewModel = FavoritesTabViewModel(coreDataService: coreDataService)
        viewModel.showMovieDetails = { [weak self] movieId in
            guard let self else { return }
            self.movieDetailsDidStarted(for: movieId)
        }
        
        viewModel.discoverMoviesTapped = { [weak self] in
            guard let self else { return }
            self.delegate?.navigateToComingSoonTab()
        }

        let favoritesTabView = FavoritesTabView(viewModel: viewModel)
            .environment(networkMonitor)
        let hostingController = UIHostingController(
            rootView: favoritesTabView.environment(\.imageLoader, self.imageLoader)
        )
        navigationController.setViewControllers([hostingController], animated: false)
    }
}

// MARK: - MovieDetails Delegate
extension FavoritesTabCoordinator: MovieDetailsCoordinatorDelegate {
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
