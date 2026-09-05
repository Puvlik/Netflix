import FirebaseAuth
import Foundation

// MARK: - RegisterState
enum RegisterState {
    case success
    case usernameNotSaved(String)
    case failed(String)
}

// MARK: - AuthServiceProtocol
protocol AuthServiceProtocol {
    var isUserAuthorized: Bool { get }
    func loginUser(email: String, password: String, completion: @escaping (String?) -> Void)
    func registerUser(username: String, email: String, password: String, completion: @escaping (RegisterState) -> Void)
    func getCurrentUser() -> AuthUserModel?
    func logoutUser() -> String?
}

// MARK: - AuthFirebaseService
final class AuthFirebaseService: AuthServiceProtocol {
    var isUserAuthorized: Bool {
        Auth.auth().currentUser != nil
    }
    
    func loginUser(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self else { return }
            if let error {
                let localizedErrorText = self.parseFirebaseError(error)
                completion(localizedErrorText)
            } else {
                completion(nil)
            }
        }
    }
    
    func registerUser(
        username: String,
        email: String,
        password: String,
        completion: @escaping (RegisterState) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, authError in
            guard let self else { return }
            
            if let authError {
                let localizedErrorText = self.parseFirebaseError(authError)
                completion(.failed(localizedErrorText))
                return
            }
            
            guard let user = authResult?.user else {
                completion(.failed(Strings.Firebase.userDataRetrieveFailedErrorText))
                return
            }
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges { [weak self] usernameError in
                guard let self else { return }
                if let usernameError {
                    let baseErrorText = self.parseFirebaseError(usernameError)
                    let finalErrorText = Strings.Firebase.usernameSetupFailedErrorText + baseErrorText
                    completion(.usernameNotSaved(finalErrorText))
                } else {
                    completion(.success)
                }
            }
        }
    }
    
    func getCurrentUser() -> AuthUserModel? {
        guard let user = Auth.auth().currentUser else { return nil }
        return AuthUserModel(id: user.uid, name: user.displayName, email: user.email)
    }
    
    func logoutUser() -> String? {
        do {
            try Auth.auth().signOut()
            return nil
        } catch {
            return parseFirebaseError(error)
        }
    }
    
    private func parseFirebaseError(_ error: Error) -> String {
        let nsError = error as NSError
        guard let errorCode = AuthErrorCode(rawValue: nsError.code) else {
            return Strings.Firebase.unknownErrorText
        }
        
        switch errorCode {
        case .emailAlreadyInUse:
            return Strings.Firebase.emailAlreadyInUseErrorText
        case .invalidCredential:
            return Strings.Firebase.invalidCredentialErrorText
        case .wrongPassword:
            return Strings.Firebase.wrongPasswordErrorText
        case .userNotFound:
            return Strings.Firebase.userNotFoundErrorText
        case .networkError:
            return Strings.Firebase.badNetworkErrorText
        case .keychainError:
            return Strings.Firebase.failedToLogoutErrorText
        default:
            return error.localizedDescription
        }
    }
}
