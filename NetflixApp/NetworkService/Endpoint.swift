import Alamofire
import Foundation

protocol Endpoint: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
}

extension Endpoint {
    var baseURL: String { Secrets.baseUrl }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        var finalParameters: Parameters = ["api_key": Secrets.apiKey]
        if let parameters = parameters {
            for (key, value) in parameters {
                finalParameters[key] = value
            }
        }
        
        return try URLEncoding.default.encode(request, with: finalParameters)
    }
}
