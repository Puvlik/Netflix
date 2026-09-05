import SwiftUI

// MARK: - MovieDetailsCoordinatorDelegate
protocol MovieDetailsCoordinatorDelegate: AnyObject {
    func movieDetailsDidStarted(for id: Int)
    func movieDetailsDidFinish(_ coordinator: MovieDetailsCoordinator)
}

// MARK: - MovieDetailsCoordinator
final class MovieDetailsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    weak var delegate: MovieDetailsCoordinatorDelegate?
    private let coreDataService: CoreDataServiceProtocol
    private let imageLoader: ImageLoadingProtocol
    private let networkMonitor: NetworkMonitorService
    private let selectedMovieId: Int

    init(
        navigationController: UINavigationController,
        coreDataService: CoreDataServiceProtocol,
        imageLoader: ImageLoadingProtocol,
        networkMonitor: NetworkMonitorService,
        movieId: Int
    ) {
        self.navigationController = navigationController
        self.coreDataService = coreDataService
        self.imageLoader = imageLoader
        self.networkMonitor = networkMonitor
        self.selectedMovieId = movieId
    }
    
    func start() {
        let networkService = NetworkService()
        let moviesService = MoviesService(networkService: networkService)
        let viewModel = MovieDetailsViewModel(
            moviesService: moviesService,
            coreDataService: coreDataService,
            id: selectedMovieId
        )
        viewModel.onDismissTapped = { [weak self] in
            guard let self else { return }
            delegate?.movieDetailsDidFinish(self)
        }
        
        viewModel.onRelatedMovieTap = { [weak self] id in
            guard let self else { return }
            delegate?.movieDetailsDidStarted(for: id)
        }
        let movieDetails = MovieDetailsView(viewModel: viewModel)
            .environment(networkMonitor)
        let hostingController = UIHostingController(
            rootView: movieDetails.environment(\.imageLoader, self.imageLoader)
        )
        hostingController.view.backgroundColor = .black
        hostingController.hidesBottomBarWhenPushed = true
        navigationController.view.backgroundColor = .black
        navigationController.pushViewController(hostingController, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - MovieDetails Delegate
extension MovieDetailsCoordinator: MovieDetailsCoordinatorDelegate {
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
