import UIKit

// MARK: - OnboardingCoordinatorDelegate
protocol OnboardingCoordinatorDelegate: AnyObject {
    func openAuthScreen(_ coordinator: OnboardingCoordinator, authStep: AuthStep)
}

// MARK: - OnboardingCoordinator
final class OnboardingCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    weak var delegate: OnboardingCoordinatorDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = OnboardingViewModel()
        viewModel.onGoToLogin = { [weak self] in
            guard let self else { return }
            UserDefaults.standard.hasSeenOnboarding = true
            self.delegate?.openAuthScreen(self, authStep: .login)
        }
        
        viewModel.onGoToRegister = { [weak self] in
            guard let self else { return }
            UserDefaults.standard.hasSeenOnboarding = true
            self.delegate?.openAuthScreen(self, authStep: .register)
        }
        
        let onboardingViewController = OnboardingViewController(viewModel: viewModel)
        navigationController.setViewControllers([onboardingViewController], animated: true)
    }
}
