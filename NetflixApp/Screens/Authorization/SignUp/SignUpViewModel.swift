import Foundation

// MARK: - SignUpViewModel
final class SignUpViewModel: PerformValidationProtocol {
    var onRegisterSuccess: (() -> Void)?
    var onRegisterUsernameNotSaved: ((String) -> Void)?
    var onRegisterFailed: ((String) -> Void)?
    var onBackButton: (() -> Void)?
    var onUsernameErrorChanged: ((String?) -> Void)?
    var onEmailErrorChanged: ((String?) -> Void)?
    var onPasswordErrorChanged: ((String?) -> Void)?
    var onConfirmPasswordErrorChanged: ((String?) -> Void)?
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
    
    private func validate(username: String, email: String, password: String, confirmPassword: String) -> Bool {
        let isUsernameValid = performValidation({
            try validator.validateUsername(username)
        }, errorClosure: onUsernameErrorChanged)
        
        let isEmailValid = performValidation({
            try validator.validateEmail(email)
        }, errorClosure: onEmailErrorChanged)

        let isPasswordValid = performValidation({
            try validator.validateMainPassword(password)
        }, errorClosure: onPasswordErrorChanged)

        let isConfirmPasswordValid = performValidation({
            try validator.validateAndCompare(password, with: confirmPassword)
        }, errorClosure: onConfirmPasswordErrorChanged)
        
        let isCredentialsValid = isUsernameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid
        return isCredentialsValid
    }
    
    func registerButtonTapped(username: String?, email: String?, password: String?, confirmPassword: String?) {
        guard !isRequestInProgress else {
            return
        }
        
        let safeUsername = username.safeTrimmed
        let safeEmail = email.safeTrimmed
        let safePassword = password.safeTrimmed
        let safeConfirmPassword = confirmPassword.safeTrimmed
        
        let isValid = validate(
            username: safeUsername,
            email: safeEmail,
            password: safePassword,
            confirmPassword: safeConfirmPassword
        )
        
        if isValid {
            isLoading?(true)
            isRequestInProgress = true
            authService.registerUser(
                username: safeUsername,
                email: safeEmail,
                password: safePassword
            ) { [weak self] result in
                guard let self else { return }
                self.isLoading?(false)
                self.isRequestInProgress = false
                
                switch result {
                case .success:
                    self.onRegisterSuccess?()
                case .usernameNotSaved(let errorText):
                    self.onRegisterUsernameNotSaved?(errorText)
                case .failed(let errorText):
                    self.onRegisterFailed?(errorText)
                }
            } 
        }
    }
    
    func closeUsernameErrorAlert() {
        onRegisterSuccess?()
    }
    
    func backButtonTapped() {
        onBackButton?()
    }
}
