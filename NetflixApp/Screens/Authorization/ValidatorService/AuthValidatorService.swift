import Foundation

// MARK: - AuthValidatorServiceProtocol
protocol AuthValidatorServiceProtocol {
    func validateUsername(_ username: String) throws
    func validateEmail(_ email: String) throws
    func validateMainPassword(_ password: String) throws
    func validateAndCompare(_ password: String, with confirmPassword: String) throws
}

// MARK: - AuthValidatorService
struct AuthValidatorService: AuthValidatorServiceProtocol {
    func validateUsername(_ username: String) throws {
        if username.isEmpty || username.count < Constants.usernameMinimumLength {
            throw AuthError.invalidUsername
        }
    }
    
    func validateEmail(_ email: String) throws {
        guard !email.isEmpty else {
            throw AuthError.emptyEmail
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if !emailPredicate.evaluate(with: email) {
            throw AuthError.invalidEmail
        }
    }

    func validateMainPassword(_ password: String) throws {
        guard !password.isEmpty else {
            throw AuthError.emptyPassword
        }
        
        if password.count < Constants.passwordMinimumLength {
            throw AuthError.passwordTooShort
        }
    }
    
    func validateAndCompare(_ password: String, with confirmPassword: String) throws {
        guard !confirmPassword.isEmpty else {
            throw AuthError.emptyConfirmPassword
        }
        
        if confirmPassword != password {
            throw AuthError.passwordsNotMatching
        }
    }
}

// MARK: - Constants
private extension AuthValidatorService {
    enum Constants {
        static var usernameMinimumLength: Int = 2
        static var passwordMinimumLength: Int = 8
    }
}
