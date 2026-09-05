import Foundation

// MARK: - SignInViewModel
final class SignInViewModel: PerformValidationProtocol {
    var onLoginSuccess: (() -> Void)?
    var onLoginFailed: ((String) -> Void)?
    var onNavigateToRegister: (() -> Void)?
    var onEmailErrorChanged: ((String?) -> Void)?
    var onPasswordErrorChanged: ((String?) -> Void)?
    var isLoading: ((Bool) -> Void)?
    
    private var isRequestInProgress: Bool = false
    private let validator: AuthValidatorService
    private let authService: AuthServiceProtocol
    
    init(
        validator: AuthValidatorService = AuthValidatorService(),
        authService: AuthServiceProtocol = AuthFirebaseService()
    ) {
        self.validator = validator
        self.authService = authService
    }
    
    func loginButtonTapped(email: String?, password: String?) {
        guard !isRequestInProgress else {
            return
        }
        
        let safeEmail = email.safeTrimmed
        let safePassword = password.safeTrimmed
        
        let isEmailValid = performValidation({
            try validator.validateEmail(safeEmail)
        }, errorClosure: onEmailErrorChanged)

        let isPasswordValid = performValidation({
            try validator.validateMainPassword(safePassword)
        }, errorClosure: onPasswordErrorChanged)

        let isCredentialsValid = isEmailValid && isPasswordValid
        if isCredentialsValid {
            isRequestInProgress = true
            isLoading?(true)
            authService.loginUser(email: safeEmail, password: safePassword) { [weak self] error in
                guard let self else { return }
                self.isRequestInProgress = false
                self.isLoading?(false)
                if let error {
                    self.onLoginFailed?(error)
                } else {
                    self.onLoginSuccess?()
                }
            }
        }
    }
    
    func registerButtonTapped() {
        onNavigateToRegister?()
    }
}
