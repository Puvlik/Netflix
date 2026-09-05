import Alamofire
import Foundation

enum APIRouter: Endpoint {
    case popularMovies(page: Int)
    case upcomingMovies(page: Int)
    case searchMovies(query: String, page: Int)
    case movieDetails(id: Int)
    case movieRecommendations(id: Int, page: Int)
    
    var path: String {
        switch self {
        case .popularMovies:
            "/movie/popular"
        case .upcomingMovies:
            "/discover/movie"
        case .searchMovies:
            "/search/movie"
        case .movieDetails(let id):
            "/movie/\(id)"
        case .movieRecommendations(let id, _):
            "/movie/\(id)/recommendations"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    private var page: Int? {
        switch self {
        case .popularMovies(let page),
                .upcomingMovies(let page),
                .searchMovies(_, let page),
                .movieRecommendations(_, let page):
            return page
        case .movieDetails:
            return nil
        }
    }
    
    var parameters: Parameters? {
        var params: Parameters = [:]

        if let page = page {
            params["page"] = page
            params["include_adult"] = "true"
        }
        
        switch self {
        case .popularMovies, .movieRecommendations:
            break
        case .upcomingMovies:
            params["primary_release_date.gte"] = Date().convertToTMDBTypeString()
        case .searchMovies(let query, _):
            params["query"] = query
        case .movieDetails:
            params["append_to_response"] = "recommendations"
        }
        
        return params
    }
}
