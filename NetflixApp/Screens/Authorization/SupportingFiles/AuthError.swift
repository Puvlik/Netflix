import Foundation

enum AuthError: LocalizedError {
    case invalidUsername
    case emptyEmail
    case invalidEmail
    case emptyPassword
    case passwordTooShort
    case emptyConfirmPassword
    case passwordsNotMatching

    var errorDescription: String? {
        switch self {
        case .invalidUsername:
            return Strings.Auth.invalidUsernameError
        case .emptyEmail:
            return Strings.Auth.emptyEmailError
        case .invalidEmail:
            return Strings.Auth.invalidEmailError
        case .emptyPassword:
            return Strings.Auth.emptyPasswordError
        case .passwordTooShort:
            return Strings.Auth.invalidPasswordError
        case .emptyConfirmPassword:
            return Strings.Auth.emptyConfirmPasswordError
        case .passwordsNotMatching:
            return Strings.Auth.passwordsNotMatchingError
        }
    }
}
