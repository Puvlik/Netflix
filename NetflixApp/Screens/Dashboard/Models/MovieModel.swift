import Foundation

struct MovieResponse: Codable {
    let results: [MovieModel]
    let totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case results
        case totalPages = "total_pages"
    }
}

struct MovieModel: Codable, Identifiable {
    let id: Int
    let title: String?
    let originalName: String?
    let runtime: Int?
    let voteAverage: Double?
    let popularity: Double?
    let releaseDate: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let isAdult: Bool
    let genres: [MovieGenre]?
    // For featured image on Home page
    let genreIds: [Int]?
    var recommendations: MovieResponse?
    
    var displayName: String {
        title ?? originalName ?? Strings.Movie.unknownMovieTitle
    }
    
    var isPosterURLValid: Bool {
        guard let posterPath else { return false }
        return !posterPath.isEmpty
    }
    
    var isBackdropURLValid: Bool {
        guard let backdropPath else { return false }
        return !backdropPath.isEmpty
    }
    
    func posterURL(size: TMDBImageSize) -> URL? {
        guard let path = posterPath, !path.isEmpty else { return nil }
        return URL(string: Secrets.baseImageUrl + size.rawValue + path)
    }

    func backdropURL(size: TMDBImageSize) -> URL? {
        guard let path = backdropPath, !path.isEmpty else { return nil }
        return URL(string: Secrets.baseImageUrl + size.rawValue + path)
    }
    
    var genreTitles: [String] {
        if let tags = genres, !tags.isEmpty {
            return tags.compactMap { $0.name }
        }
        
        if let tags = genreIds, !tags.isEmpty {
            return tags.compactMap { MovieGenreIdentifiers(rawValue: $0)?.title }
        }

        return []
    }

    enum CodingKeys: String, CodingKey {
        case id, overview, title, runtime, genres, recommendations, popularity
        case originalName = "original_name"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case isAdult = "adult"
        case genreIds = "genre_ids"
    }
}

// Map from Core Data Entity
extension MovieModel {
    init(entity: MovieEntity) {
        self.init(
            id: Int(entity.id),
            title: entity.title ?? Strings.Common.emptyString,
            originalName: nil,
            runtime: nil,
            voteAverage: nil,
            popularity: nil,
            releaseDate: entity.releaseDate,
            overview: nil,
            posterPath: nil,
            backdropPath: entity.backdropPath,
            isAdult: entity.isAdult,
            genres: nil,
            genreIds: nil,
            recommendations: nil
        )
    }
}

extension MovieModel: Equatable {
    static func == (lhs: MovieModel, rhs: MovieModel) -> Bool {
        lhs.id == rhs.id
    }
}
