import UIKit

// MARK: - TabBarCoordinatorDelegate
protocol TabBarCoordinatorDelegate: AnyObject {
    func tabBarDidFinish(_ coordinator: TabBarCoordinator)
}

// MARK: - TabNavigationController
final class TabNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - TabBarCoordinator
final class TabBarCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    weak var delegate: TabBarCoordinatorDelegate?
    private var tabBarController: UITabBarController?
    private var tabNavigationControllers = [Int: UINavigationController]()
    private var loadedTabs = Set<Int>()
    
    private let coreDataService: AppCoreDataServices
    private let imageCache: ImageCachingProtocol
    private let imageLoader: ImageLoadingProtocol
    private let networkMonitor: NetworkMonitorService
    
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
        super.init()
    }
    
    func start() {
        let tabBarController = setupCustomTabBar()
        tabBarController.delegate = self
        tabBarController.viewControllers = MovieTabs.allCases.map { tab in
            makeTabNavigationController(for: tab)
        }
        self.tabBarController = tabBarController
        loadTabIfNeeded(.home)
        if let tabBarController = self.tabBarController {
            navigationController.setViewControllers([tabBarController], animated: true)
        }
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupCustomTabBar() -> UITabBarController {
        let tabBarController = UITabBarController()
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.normal.iconColor = Assets.Colors.tabNotSelected.color
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: Assets.Colors.tabNotSelected.color
        ]

        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        return tabBarController
    }
    
    private func loadTabIfNeeded(_ tab: MovieTabs) {
        guard !loadedTabs.contains(tab.index),
              let tabNavigationController = tabNavigationControllers[tab.index]
        else { return }

        loadedTabs.insert(tab.index)
        let coordinator = makeCoordinator(for: tab, navigationController: tabNavigationController)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    private func makeTabNavigationController(for tab: MovieTabs) -> UINavigationController {
        let tabNavigationController = TabNavigationController()
        tabNavigationController.tabBarItem = UITabBarItem(
            title: tab.rawValue,
            image: UIImage(systemName: tab.systemImageName),
            tag: tab.index
        )

        tabNavigationControllers[tab.index] = tabNavigationController
        return tabNavigationController
    }
    
    private func makeCoordinator(for tab: MovieTabs, navigationController: UINavigationController) -> Coordinator {
        switch tab {
        case .home:
            let homeCoordinator = HomeTabCoordinator(
                navigationController: navigationController,
                coreDataService: coreDataService,
                imageCache: imageCache,
                imageLoader: imageLoader,
                networkMonitor: networkMonitor
            )
            homeCoordinator.delegate = self
            homeCoordinator.cacheDelegate = self
            return homeCoordinator
        case .comingSoon:
            return ComingSoonTabCoordinator(
                navigationController: navigationController,
                coreDataService: coreDataService,
                imageLoader: imageLoader,
                networkMonitor: networkMonitor
            )
        case .favorites:
            let favoritesCoordinator = FavoritesTabCoordinator(
                navigationController: navigationController,
                coreDataService: coreDataService,
                imageLoader: imageLoader,
                networkMonitor: networkMonitor
            )
            favoritesCoordinator.delegate = self
            return favoritesCoordinator
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        guard let tab = MovieTabs(index: viewController.tabBarItem.tag) else { return true }
        loadTabIfNeeded(tab)
        return true
    }
}

// MARK: - HomeTabCoordinatorDelegate
extension TabBarCoordinator: HomeTabCoordinatorDelegate {
    func homeTabDidFinish(_ coordinator: HomeTabCoordinator) {
        self.delegate?.tabBarDidFinish(self)
    }
}

// MARK: - FavoritesTabCoordinatorDelegate
extension TabBarCoordinator: FavoritesTabCoordinatorDelegate {
    func navigateToComingSoonTab() {
        loadTabIfNeeded(.comingSoon)
        self.tabBarController?.selectedIndex = MovieTabs.comingSoon.index
    }
}

// MARK: - CacheClearingDelegate
extension TabBarCoordinator: CacheClearingDelegate {
    func didClearLocalCache() {
        childCoordinators
            .compactMap { $0 as? CacheRefreshableDelegate }
            .forEach { $0.refreshAfterCacheCleared() }
    }
}
