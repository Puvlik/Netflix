import UIKit

// MARK: - SplashCoordinatorDelegate
protocol SplashCoordinatorDelegate: AnyObject {
    func splashDidFinish(_ coordinator: SplashCoordinator)
}

// MARK: - SplashCoordinator
final class SplashCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    weak var delegate: SplashCoordinatorDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SplashViewModel()
        viewModel.splashFinished = { [weak self] in
            guard let self else { return }
            self.delegate?.splashDidFinish(self)
        }
        
        let splashViewController = SplashViewController(viewModel: viewModel)
        navigationController.setViewControllers([splashViewController], animated: false)
    }
}
