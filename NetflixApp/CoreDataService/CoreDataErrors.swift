import Foundation

enum CoreDataError: Error {
    case addToCoreDataFailed
    case addToFavoritesFailed
    case removeFromFavoritesFailed
    case moviesFetchFailed
    case favoriteMovieFetchFailed
    case isFavoriteStatusCheckFailed
    
    var alertTitle: String {
        switch self {
        case .addToCoreDataFailed:
            Strings.CoreData.addToCoreDataFailedTitle
        case .addToFavoritesFailed:
            Strings.CoreData.savingFailedAlertTitle
        case .moviesFetchFailed, .favoriteMovieFetchFailed:
            Strings.CoreData.fetchingFailedAlertTitle
        case .removeFromFavoritesFailed:
            Strings.CoreData.deletionFailedAlertTitle
        case .isFavoriteStatusCheckFailed:
            Strings.CoreData.favoriteStatusCheckFailedAlertTitle
        }
    }
    
    var errorDescription: String {
        switch self {
        case .addToCoreDataFailed:
            Strings.CoreData.addToCoreDataFailedDescription
        case .addToFavoritesFailed:
            Strings.CoreData.savingFailedAlertDescription
        case .moviesFetchFailed:
            Strings.CoreData.fetchingMoviesFailedAlertDescription
        case .favoriteMovieFetchFailed:
            Strings.CoreData.fetchingFavoriteMovieFailedAlertDescription
        case .removeFromFavoritesFailed:
            Strings.CoreData.deletionFailedAlertDescription
        case .isFavoriteStatusCheckFailed:
            Strings.CoreData.favoriteStatusCheckFailedAlertDescription
        }
    }
}
