import Alamofire
import Foundation

protocol NetworkServiceProtocol {
    func performRequest<T: Decodable>(endpoint: Endpoint) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    func performRequest<T: Decodable>(endpoint: Endpoint) async throws -> T {
        do {
            return try await AF.request(endpoint)
                .validate()
                .serializingDecodable(T.self, decoder: JSONDecoder())
                .value
        } catch let error as AFError {
            if case .explicitlyCancelled = error {
                throw CancellationError()
            }
            
            if let urlError = error.underlyingError as? URLError,
               urlError.code == .cancelled {
                throw urlError
            }
            
            if case .responseSerializationFailed(let reason) = error,
               case .decodingFailed = reason {
                throw NetworkManagerError.decodingError
            }
            
            throw NetworkManagerError.mapToUserFriendly(error)
        } catch let error as CancellationError {
            throw error
        } catch is DecodingError {
            throw NetworkManagerError.decodingError
        } catch {
            throw NetworkManagerError.unknown
        }
    }
}
