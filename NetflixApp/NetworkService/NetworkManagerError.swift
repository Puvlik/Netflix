import Alamofire
import Foundation

enum NetworkManagerError: Error, LocalizedError, Equatable {
    case offline
    case timeout
    case serverError(code: Int)
    case cancelled
    case decodingError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .offline, .timeout:
            return Strings.Alamofire.checkInternetConnectionError
        case .serverError(let code):
            if code == 401 {
                return Strings.Alamofire.authenticationError
            }
            
            return Strings.Alamofire.failedWithErrorCode(code)
        case .cancelled:
            return nil
        case .decodingError:
            return Strings.Alamofire.failedWithDecodingError
        case .unknown:
            return Strings.Alamofire.unknownErrorOccured
        }
    }
    
    static func mapToUserFriendly(_ alamofireError: AFError) -> NetworkManagerError {
        if let urlError = alamofireError.underlyingError as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
                return .offline
            case .timedOut:
                return .timeout
            case .cancelled:
                return .cancelled
            default:
                break
            }
        }
        
        if case .explicitlyCancelled = alamofireError {
            return .cancelled
        }
        
        if case .responseValidationFailed(let reason) = alamofireError,
           case .unacceptableStatusCode(let code) = reason {
            return .serverError(code: code)
        }

        return .unknown
    }
}
