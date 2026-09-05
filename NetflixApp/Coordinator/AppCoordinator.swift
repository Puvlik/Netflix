import UIKit

// MARK: - AppCoordinator
final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    private let authService: AuthServiceProtocol
    private let coreDataService: AppCoreDataServices
    private let imageCache: ImageCachingProtocol
    private let imageLoader: ImageLoadingProtocol
    private let networkMonitor: NetworkMonitorService
    
    init(
        navigationController: UINavigationController,
        authService: AuthServiceProtocol = AuthFirebaseService(),
        coreDataService: AppCoreDataServices,
        imageCache: ImageCachingProtocol,
        networkMonitor: NetworkMonitorService
    ) {
        self.navigationController = navigationController
        self.authService = authService
        self.coreDataService = coreDataService
        self.imageCache = imageCache
        self.imageLoader = ImageLoaderService(cache: imageCache)
        self.networkMonitor = networkMonitor
    }
    
    func start() {
        showSplashScreenFlow()
    }
    
    private func showSplashScreenFlow() {
        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        splashCoordinator.delegate = self
        addChildCoordinator(splashCoordinator)
        splashCoordinator.start()
    }
    
    private func showOnboardingScreenFlow() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator.delegate = self
        addChildCoordinator(onboardingCoordinator)
        onboardingCoordinator.start()
    }

    private func showAuthFlow(authStep: AuthStep) {
        let authCoordinator = AuthCoordinator(navigationController: navigationController, authStep: authStep)
        authCoordinator.delegate = self
        addChildCoordinator(authCoordinator)
        authCoordinator.start()
    }
    
    private func showDashboardFlow() {
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            coreDataService: coreDataService,
            imageCache: imageCache,
            imageLoader: imageLoader,
            networkMonitor: networkMonitor
        )
        tabBarCoordinator.delegate = self
        addChildCoordinator(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}

// MARK: - Splash Delegate
extension AppCoordinator: SplashCoordinatorDelegate {
    func splashDidFinish(_ coordinator: SplashCoordinator) {
        removeChildCoordinator(coordinator)
        let isLoggedIn = authService.isUserAuthorized
        let skipOnboardingFlow = UserDefaults.standard.hasSeenOnboarding
        if !skipOnboardingFlow {
            showOnboardingScreenFlow()
        } else if !isLoggedIn {
            showAuthFlow(authStep: .login)
        } else {
            showDashboardFlow()
        }
    }
}

// MARK: - Onboarding Delegate
extension AppCoordinator: OnboardingCoordinatorDelegate {
    func openAuthScreen(_ coordinator: OnboardingCoordinator, authStep: AuthStep) {
        if authStep == .login {
            removeChildCoordinator(coordinator)
        }
        
        showAuthFlow(authStep: authStep)
    }
}

// MARK: - Auth Delegate
extension AppCoordinator: AuthCoordinatorDelegate {
    func authDidFinish(_ coordinator: AuthCoordinator) {
        /* Onboarding coordinator is still alive when Auth flow is active,
         so we need to delete them both after Auth finished successfully */
        removeAllChildCoordinators()
        showDashboardFlow()
    }
}

// MARK: - TabBarCoordinatorDelegate
extension AppCoordinator: TabBarCoordinatorDelegate {
    func tabBarDidFinish(_ coordinator: TabBarCoordinator) {
        removeAllChildCoordinators()
        navigationController.viewControllers.removeAll()
        showAuthFlow(authStep: .login)
    }
}
