import SwiftUI

typealias ProfileDependencies = CoreDataCacheClearingProtocol & FavoriteMoviesCounterProtocol

// MARK: - ProfileCoordinatorDelegate
protocol ProfileCoordinatorDelegate: AnyObject {
    func profileDidStarted()
    func profileDidClosed(_ coordinator: ProfileCoordinator)
    func profileDidLogout(_ coordinator: ProfileCoordinator)
}

// MARK: - ProfileCoordinator
final class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    weak var delegate: ProfileCoordinatorDelegate?
    weak var cacheDelegate: CacheClearingDelegate?
    private let coreDataService: ProfileDependencies
    private let imageCache: ImageCachingProtocol
    private let networkMonitor: NetworkMonitorService

    init(
        navigationController: UINavigationController,
        coreDataService: ProfileDependencies,
        imageCache: ImageCachingProtocol,
        networkMonitor: NetworkMonitorService,
    ) {
        self.navigationController = navigationController
        self.coreDataService = coreDataService
        self.imageCache = imageCache
        self.networkMonitor = networkMonitor
    }

    func start() {
        let authService = AuthFirebaseService()
        let viewModel = ProfileViewModel(
            authService: authService,
            coreDataService: coreDataService,
            imageCache: imageCache
        )
        viewModel.onDismissTapped = { [weak self] in
            guard let self else { return }
            self.delegate?.profileDidClosed(self)
        }
        
        viewModel.onLogoutSuccess = { [weak self] in
            guard let self else { return }
            self.delegate?.profileDidLogout(self)
        }
        
        viewModel.onCacheCleared = { [weak self] in
            guard let self else { return }
            self.cacheDelegate?.didClearLocalCache()
        }
        
        let profileView = ProfilePageView(viewModel: viewModel)
            .environment(networkMonitor)
        let hostingController = UIHostingController(rootView: profileView)
        hostingController.view.backgroundColor = .black
        hostingController.hidesBottomBarWhenPushed = true
        navigationController.view.backgroundColor = .black
        navigationController.pushViewController(hostingController, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}
