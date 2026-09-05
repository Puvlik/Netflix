import Foundation

struct MovieGenre: Codable {
    let id: Int
    let name: String
}

enum MovieGenreIdentifiers: Int, CaseIterable {
    case adventure = 12
    case fantasy = 14
    case animation = 16
    case drama = 18
    case horror = 27
    case action = 28
    case comedy = 35
    case history = 36
    case western = 37
    case thriller = 53
    case crime = 80
    case documentary = 99
    case sciFi = 878
    case mystery = 9648
    case music = 10402
    case romance = 10749
    case family = 10751
    case war = 10752
    case tvMovie = 10770

    var title: String {
        switch self {
        case .adventure:
            return Strings.Movie.Genre.adventure
        case .fantasy:
            return Strings.Movie.Genre.fantasy
        case .animation:
            return Strings.Movie.Genre.animation
        case .drama:
            return Strings.Movie.Genre.drama
        case .horror:
            return Strings.Movie.Genre.horror
        case .action:
            return Strings.Movie.Genre.action
        case .comedy:
            return Strings.Movie.Genre.comedy
        case .history:
            return Strings.Movie.Genre.history
        case .western:
            return Strings.Movie.Genre.western
        case .thriller:
            return Strings.Movie.Genre.thriller
        case .crime:
            return Strings.Movie.Genre.crime
        case .documentary:
            return Strings.Movie.Genre.documentary
        case .sciFi:
            return Strings.Movie.Genre.sciFi
        case .mystery:
            return Strings.Movie.Genre.mystery
        case .music:
            return Strings.Movie.Genre.music
        case .romance:
            return Strings.Movie.Genre.romance
        case .family:
            return Strings.Movie.Genre.family
        case .war:
            return Strings.Movie.Genre.war
        case .tvMovie:
            return Strings.Movie.Genre.tvMovie
        }
    }
}
