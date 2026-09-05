import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator?
    private let coreDataStack = CoreDataStack()
    private let networkMonitor = NetworkMonitorService()
    private lazy var coreDataService = CoreDataService(container: coreDataStack.persistentContainer)
    private lazy var imageCache = LocalImageCacheManager()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
        coordinator = AppCoordinator(
            navigationController: navigationController,
            coreDataService: coreDataService,
            imageCache: imageCache,
            networkMonitor: networkMonitor
        )
        coordinator?.start()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        let coreDataService = self.coreDataService
        coreDataStack.saveContext()
        
        Task.detached(priority: .background) {
            await coreDataService.runGarbageCollector()
        }
    }
}
