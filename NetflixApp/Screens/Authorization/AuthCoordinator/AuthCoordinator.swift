import UIKit

// MARK: - AuthCoordinatorDelegate
protocol AuthCoordinatorDelegate: AnyObject {
    func authDidFinish(_ coordinator: AuthCoordinator)
}

enum AuthStep {
    case login
    case register
}

// MARK: - AuthCoordinator
final class AuthCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var authStep: AuthStep
    weak var delegate: AuthCoordinatorDelegate?
    
    init(navigationController: UINavigationController, authStep: AuthStep) {
        self.navigationController = navigationController
        self.authStep = authStep
    }
    
    func start() {
        if authStep == .login {
            showSignIn()
        } else {
            showSignUp()
        }
    }

    private func showSignIn() {
        let viewModel = SignInViewModel()
        viewModel.onLoginSuccess = { [weak self] in
            guard let self else { return }
            self.delegate?.authDidFinish(self)
        }
        
        viewModel.onNavigateToRegister = { [weak self] in
            guard let self else { return }
            self.showSignUp()
        }
        
        let signInViewController = SignInViewController(viewModel: viewModel)
        navigationController.setViewControllers([signInViewController], animated: true)
    }
    
    private func showSignUp() {
        let viewModel = SignUpViewModel()
        viewModel.onRegisterSuccess = { [weak self] in
            guard let self else { return }
            self.delegate?.authDidFinish(self)
        }
        
        viewModel.onBackButton = { [weak self] in
            guard let self else { return }
            self.navigationController.popViewController(animated: true)
        }
        
        let signUpViewController = SignUpViewController(viewModel: viewModel)
        navigationController.pushViewController(signUpViewController, animated: true)
    }
}
