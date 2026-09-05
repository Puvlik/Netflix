// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  internal enum Alamofire {
    /// Authentication error. Please sign out and sign in
    internal static let authenticationError = Strings.tr("Localizable", "alamofire.authenticationError", fallback: "Authentication error. Please sign out and sign in")
    /// Please check your internet connection and try again
    internal static let checkInternetConnectionError = Strings.tr("Localizable", "alamofire.checkInternetConnectionError", fallback: "Please check your internet connection and try again")
    /// Failed to Load Movies
    internal static let failedToLoadMoviesAlertTitle = Strings.tr("Localizable", "alamofire.failedToLoadMoviesAlertTitle", fallback: "Failed to Load Movies")
    /// We are having trouble loading the movie data right now
    internal static let failedWithDecodingError = Strings.tr("Localizable", "alamofire.failedWithDecodingError", fallback: "We are having trouble loading the movie data right now")
    /// The server returned an error (Code: %d). Please try again later
    internal static func failedWithErrorCode(_ p1: Int) -> String {
      return Strings.tr("Localizable", "alamofire.failedWithErrorCode", p1, fallback: "The server returned an error (Code: %d). Please try again later")
    }
    /// An unknown network error occurred
    internal static let unknownErrorOccured = Strings.tr("Localizable", "alamofire.unknownErrorOccured", fallback: "An unknown network error occurred")
  }
  internal enum Auth {
    /// Confirm password
    internal static let confirmPasswordFieldPlaceholder = Strings.tr("Localizable", "auth.confirmPasswordFieldPlaceholder", fallback: "Confirm password")
    /// Email
    internal static let emailFieldPlaceholder = Strings.tr("Localizable", "auth.emailFieldPlaceholder", fallback: "Email")
    /// Confirm Password cannot be empty
    internal static let emptyConfirmPasswordError = Strings.tr("Localizable", "auth.emptyConfirmPasswordError", fallback: "Confirm Password cannot be empty")
    /// Email cannot be empty
    internal static let emptyEmailError = Strings.tr("Localizable", "auth.emptyEmailError", fallback: "Email cannot be empty")
    /// Password cannot be empty
    internal static let emptyPasswordError = Strings.tr("Localizable", "auth.emptyPasswordError", fallback: "Password cannot be empty")
    /// HIDE
    internal static let hidePasswordButtonTitle = Strings.tr("Localizable", "auth.hidePasswordButtonTitle", fallback: "HIDE")
    /// Please enter a valid email address
    internal static let invalidEmailError = Strings.tr("Localizable", "auth.invalidEmailError", fallback: "Please enter a valid email address")
    /// Password must be at least 8 characters
    internal static let invalidPasswordError = Strings.tr("Localizable", "auth.invalidPasswordError", fallback: "Password must be at least 8 characters")
    /// Username must be at least 2 characters
    internal static let invalidUsernameError = Strings.tr("Localizable", "auth.invalidUsernameError", fallback: "Username must be at least 2 characters")
    /// Login
    internal static let loginButtonTitle = Strings.tr("Localizable", "auth.loginButtonTitle", fallback: "Login")
    /// Password
    internal static let passwordFieldPlaceholder = Strings.tr("Localizable", "auth.passwordFieldPlaceholder", fallback: "Password")
    /// Passwords don't match
    internal static let passwordsNotMatchingError = Strings.tr("Localizable", "auth.passwordsNotMatchingError", fallback: "Passwords don't match")
    /// Register
    internal static let registerButtonTitle = Strings.tr("Localizable", "auth.registerButtonTitle", fallback: "Register")
    /// SHOW
    internal static let showPasswordButtonTitle = Strings.tr("Localizable", "auth.showPasswordButtonTitle", fallback: "SHOW")
    /// Username
    internal static let usernameFieldPlaceholder = Strings.tr("Localizable", "auth.usernameFieldPlaceholder", fallback: "Username")
  }
  internal enum ComingSoon {
    /// No movies found for "%@"
    internal static func emptySearchListText(_ p1: Any) -> String {
      return Strings.tr("Localizable", "comingSoon.emptySearchListText", String(describing: p1), fallback: "No movies found for \"%@\"")
    }
    /// Failed to load Coming Soon Movies
    internal static let failedToLoadComingSoonAlertTitle = Strings.tr("Localizable", "comingSoon.failedToLoadComingSoonAlertTitle", fallback: "Failed to load Coming Soon Movies")
    /// Coming Soon Movies are not available. An unknown error occurred
    internal static let failedToLoadComingSoonErrorText = Strings.tr("Localizable", "comingSoon.failedToLoadComingSoonErrorText", fallback: "Coming Soon Movies are not available. An unknown error occurred")
    /// Search
    internal static let searchBarPlaceholder = Strings.tr("Localizable", "comingSoon.searchBarPlaceholder", fallback: "Search")
  }
  internal enum Common {
    /// Cancel
    internal static let cancelButtonTitle = Strings.tr("Localizable", "common.cancelButtonTitle", fallback: "Cancel")
    /// Clear
    internal static let clearButtonTitle = Strings.tr("Localizable", "common.clearButtonTitle", fallback: "Clear")
    /// DELETE
    internal static let deleteButtonTitle = Strings.tr("Localizable", "common.deleteButtonTitle", fallback: "DELETE")
    /// 
    internal static let emptyString = Strings.tr("Localizable", "common.emptyString", fallback: "")
    /// OK
    internal static let okButtonTitle = Strings.tr("Localizable", "common.okButtonTitle", fallback: "OK")
    ///  
    internal static let stringWithSpaceCharacter = Strings.tr("Localizable", "common.stringWithSpaceCharacter", fallback: " ")
    /// Try Again
    internal static let tryAgainButtonTitle = Strings.tr("Localizable", "common.tryAgainButtonTitle", fallback: "Try Again")
  }
  internal enum CoreData {
    /// We couldn't save this movie lo local cache
    internal static let addToCoreDataFailedDescription = Strings.tr("Localizable", "coreData.addToCoreDataFailedDescription", fallback: "We couldn't save this movie lo local cache")
    /// Failed to cache movie
    internal static let addToCoreDataFailedTitle = Strings.tr("Localizable", "coreData.addToCoreDataFailedTitle", fallback: "Failed to cache movie")
    /// We couldn't complete this action right now. Please give it another try!
    internal static let commonErrorDescription = Strings.tr("Localizable", "coreData.commonErrorDescription", fallback: "We couldn't complete this action right now. Please give it another try!")
    /// Something Went Wrong
    internal static let commonErrorTitle = Strings.tr("Localizable", "coreData.commonErrorTitle", fallback: "Something Went Wrong")
    /// We couldn't remove this movie from your favorites. Please try again later
    internal static let deletionFailedAlertDescription = Strings.tr("Localizable", "coreData.deletionFailedAlertDescription", fallback: "We couldn't remove this movie from your favorites. Please try again later")
    /// Removal Failed
    internal static let deletionFailedAlertTitle = Strings.tr("Localizable", "coreData.deletionFailedAlertTitle", fallback: "Removal Failed")
    /// Could not verify if this movie is currently in your favorites
    internal static let favoriteStatusCheckFailedAlertDescription = Strings.tr("Localizable", "coreData.favoriteStatusCheckFailedAlertDescription", fallback: "Could not verify if this movie is currently in your favorites")
    /// Couldn't Verify Status
    internal static let favoriteStatusCheckFailedAlertTitle = Strings.tr("Localizable", "coreData.favoriteStatusCheckFailedAlertTitle", fallback: "Couldn't Verify Status")
    /// Load Failed
    internal static let fetchingFailedAlertTitle = Strings.tr("Localizable", "coreData.fetchingFailedAlertTitle", fallback: "Load Failed")
    /// We couldn't load this movie at this time. Please try again
    internal static let fetchingFavoriteMovieFailedAlertDescription = Strings.tr("Localizable", "coreData.fetchingFavoriteMovieFailedAlertDescription", fallback: "We couldn't load this movie at this time. Please try again")
    /// We couldn't load your favorite movies at this time. Please try again
    internal static let fetchingMoviesFailedAlertDescription = Strings.tr("Localizable", "coreData.fetchingMoviesFailedAlertDescription", fallback: "We couldn't load your favorite movies at this time. Please try again")
    /// We couldn't save this movie to your favorites. Please try again later
    internal static let savingFailedAlertDescription = Strings.tr("Localizable", "coreData.savingFailedAlertDescription", fallback: "We couldn't save this movie to your favorites. Please try again later")
    /// Save Failed
    internal static let savingFailedAlertTitle = Strings.tr("Localizable", "coreData.savingFailedAlertTitle", fallback: "Save Failed")
  }
  internal enum Favourites {
    /// Discover Movies
    internal static let discoverMoviesButtonTitle = Strings.tr("Localizable", "favourites.discoverMoviesButtonTitle", fallback: "Discover Movies")
    /// Explore the Coming Soon tab, select a movie you're interested in, and like it to add it to this page
    internal static let emptyFavouriteMoviesListDescription = Strings.tr("Localizable", "favourites.emptyFavouriteMoviesListDescription", fallback: "Explore the Coming Soon tab, select a movie you're interested in, and like it to add it to this page")
    /// No Favorites Yet
    internal static let emptyFavouriteMoviesListTitle = Strings.tr("Localizable", "favourites.emptyFavouriteMoviesListTitle", fallback: "No Favorites Yet")
    /// Something went wrong.
    /// Please try again and reload page
    internal static let fetchingFailedDescription = Strings.tr("Localizable", "favourites.fetchingFailedDescription", fallback: "Something went wrong.\nPlease try again and reload page")
    /// Movies not loaded
    internal static let fetchingFailedTitle = Strings.tr("Localizable", "favourites.fetchingFailedTitle", fallback: "Movies not loaded")
    /// Reload
    internal static let reloadButtonTitle = Strings.tr("Localizable", "favourites.reloadButtonTitle", fallback: "Reload")
  }
  internal enum Firebase {
    /// Network error. Please check your internet connection and try again
    internal static let badNetworkErrorText = Strings.tr("Localizable", "firebase.badNetworkErrorText", fallback: "Network error. Please check your internet connection and try again")
    /// This email is already in use. Please log in or register with another email
    internal static let emailAlreadyInUseErrorText = Strings.tr("Localizable", "firebase.emailAlreadyInUseErrorText", fallback: "This email is already in use. Please log in or register with another email")
    /// Unable to clear your secure session. Please close the app and try again
    internal static let failedToLogoutErrorText = Strings.tr("Localizable", "firebase.failedToLogoutErrorText", fallback: "Unable to clear your secure session. Please close the app and try again")
    /// Invalid email or password. Please try again
    internal static let invalidCredentialErrorText = Strings.tr("Localizable", "firebase.invalidCredentialErrorText", fallback: "Invalid email or password. Please try again")
    /// Login Failed
    internal static let loginFailedAlertErrorTitle = Strings.tr("Localizable", "firebase.loginFailedAlertErrorTitle", fallback: "Login Failed")
    /// Register Failed
    internal static let registerFailedAlertErrorTitle = Strings.tr("Localizable", "firebase.registerFailedAlertErrorTitle", fallback: "Register Failed")
    /// An unexpected error occurred. Please try again
    internal static let unknownErrorText = Strings.tr("Localizable", "firebase.unknownErrorText", fallback: "An unexpected error occurred. Please try again")
    /// Account created, but failed to retrieve user data
    internal static let userDataRetrieveFailedErrorText = Strings.tr("Localizable", "firebase.userDataRetrieveFailedErrorText", fallback: "Account created, but failed to retrieve user data")
    /// Username Not Saved
    internal static let usernameNotSavedAlertErrorTitle = Strings.tr("Localizable", "firebase.usernameNotSavedAlertErrorTitle", fallback: "Username Not Saved")
    /// Account created, but failed to save username. 
    internal static let usernameSetupFailedErrorText = Strings.tr("Localizable", "firebase.usernameSetupFailedErrorText", fallback: "Account created, but failed to save username. ")
    /// Can't find an account with that email
    internal static let userNotFoundErrorText = Strings.tr("Localizable", "firebase.userNotFoundErrorText", fallback: "Can't find an account with that email")
    /// The password you entered is incorrect
    internal static let wrongPasswordErrorText = Strings.tr("Localizable", "firebase.wrongPasswordErrorText", fallback: "The password you entered is incorrect")
  }
  internal enum HomeTab {
    /// Failed to load Popular Movies
    internal static let failedToLoadPopularMoviesAlertTitle = Strings.tr("Localizable", "homeTab.failedToLoadPopularMoviesAlertTitle", fallback: "Failed to load Popular Movies")
    /// Like
    internal static let likeButtonTitle = Strings.tr("Localizable", "homeTab.likeButtonTitle", fallback: "Like")
    /// Movies are not available. An unknown error occurred
    internal static let moviesUnavailableErrorText = Strings.tr("Localizable", "homeTab.moviesUnavailableErrorText", fallback: "Movies are not available. An unknown error occurred")
    /// Play
    internal static let playButtonTitle = Strings.tr("Localizable", "homeTab.playButtonTitle", fallback: "Play")
    /// Popular Movies
    internal static let popularMoviesSectionTitle = Strings.tr("Localizable", "homeTab.popularMoviesSectionTitle", fallback: "Popular Movies")
    /// Unlike
    internal static let unlikeButtonTitle = Strings.tr("Localizable", "homeTab.unlikeButtonTitle", fallback: "Unlike")
  }
  internal enum Movie {
    /// Unknown Title
    internal static let unknownMovieTitle = Strings.tr("Localizable", "movie.unknownMovieTitle", fallback: "Unknown Title")
    internal enum Genre {
      /// Action
      internal static let action = Strings.tr("Localizable", "movie.genre.action", fallback: "Action")
      /// Adventure
      internal static let adventure = Strings.tr("Localizable", "movie.genre.adventure", fallback: "Adventure")
      /// Animation
      internal static let animation = Strings.tr("Localizable", "movie.genre.animation", fallback: "Animation")
      /// Comedy
      internal static let comedy = Strings.tr("Localizable", "movie.genre.comedy", fallback: "Comedy")
      /// Crime
      internal static let crime = Strings.tr("Localizable", "movie.genre.crime", fallback: "Crime")
      /// Documentary
      internal static let documentary = Strings.tr("Localizable", "movie.genre.documentary", fallback: "Documentary")
      /// Drama
      internal static let drama = Strings.tr("Localizable", "movie.genre.drama", fallback: "Drama")
      /// Family
      internal static let family = Strings.tr("Localizable", "movie.genre.family", fallback: "Family")
      /// Fantasy
      internal static let fantasy = Strings.tr("Localizable", "movie.genre.fantasy", fallback: "Fantasy")
      /// History
      internal static let history = Strings.tr("Localizable", "movie.genre.history", fallback: "History")
      /// Horror
      internal static let horror = Strings.tr("Localizable", "movie.genre.horror", fallback: "Horror")
      /// Music
      internal static let music = Strings.tr("Localizable", "movie.genre.music", fallback: "Music")
      /// Mystery
      internal static let mystery = Strings.tr("Localizable", "movie.genre.mystery", fallback: "Mystery")
      /// Romance
      internal static let romance = Strings.tr("Localizable", "movie.genre.romance", fallback: "Romance")
      /// Science Fiction
      internal static let sciFi = Strings.tr("Localizable", "movie.genre.sciFi", fallback: "Science Fiction")
      /// Thriller
      internal static let thriller = Strings.tr("Localizable", "movie.genre.thriller", fallback: "Thriller")
      /// TV Movie
      internal static let tvMovie = Strings.tr("Localizable", "movie.genre.tvMovie", fallback: "TV Movie")
      /// War
      internal static let war = Strings.tr("Localizable", "movie.genre.war", fallback: "War")
      /// Western
      internal static let western = Strings.tr("Localizable", "movie.genre.western", fallback: "Western")
    }
  }
  internal enum MovieDetails {
    /// Failed to load Movie Details
    internal static let failedToLoadMoviesDetailsAlertTitle = Strings.tr("Localizable", "movieDetails.failedToLoadMoviesDetailsAlertTitle", fallback: "Failed to load Movie Details")
    /// Movie Details are not available. An unknown error occurred
    internal static let failedToLoadMoviesDetailsErrorText = Strings.tr("Localizable", "movieDetails.failedToLoadMoviesDetailsErrorText", fallback: "Movie Details are not available. An unknown error occurred")
    /// Failed to load Related Movies
    internal static let failedToLoadRelatedMoviesAlertTitle = Strings.tr("Localizable", "movieDetails.failedToLoadRelatedMoviesAlertTitle", fallback: "Failed to load Related Movies")
    /// Related Movies are not available. An unknown error occurred
    internal static let failedToLoadRelatedMoviesErrorText = Strings.tr("Localizable", "movieDetails.failedToLoadRelatedMoviesErrorText", fallback: "Related Movies are not available. An unknown error occurred")
    /// Hide more...
    internal static let hideMoreButtonText = Strings.tr("Localizable", "movieDetails.hideMoreButtonText", fallback: "Hide more...")
    /// Genre
    internal static let infoSectionGenreTitle = Strings.tr("Localizable", "movieDetails.infoSectionGenreTitle", fallback: "Genre")
    /// Release date
    internal static let infoSectionReleaseDateTitle = Strings.tr("Localizable", "movieDetails.infoSectionReleaseDateTitle", fallback: "Release date")
    /// Synopsis
    internal static let movieDescriptionSectionTitle = Strings.tr("Localizable", "movieDetails.movieDescriptionSectionTitle", fallback: "Synopsis")
    /// No rating
    internal static let movieRatingNotFound = Strings.tr("Localizable", "movieDetails.movieRatingNotFound", fallback: "No rating")
    /// Not found
    internal static let movieReleaseDateNotFound = Strings.tr("Localizable", "movieDetails.movieReleaseDateNotFound", fallback: "Not found")
    /// Not found
    internal static let movieRuntimeNotFound = Strings.tr("Localizable", "movieDetails.movieRuntimeNotFound", fallback: "Not found")
    /// %d minutes
    internal static func movieRuntimeText(_ p1: Int) -> String {
      return Strings.tr("Localizable", "movieDetails.movieRuntimeText", p1, fallback: "%d minutes")
    }
    /// Read more...
    internal static let readMoreButtonText = Strings.tr("Localizable", "movieDetails.readMoreButtonText", fallback: "Read more...")
    /// Related Movies
    internal static let relatedMoviesSectionTitle = Strings.tr("Localizable", "movieDetails.relatedMoviesSectionTitle", fallback: "Related Movies")
  }
  internal enum Onboarding {
    /// You can’t sign up for Netflix in the app. We know it’s a hassle. After you’re a member, you can start watching in the app. 
    /// Scroll > to learn more
    internal static let firstBody = Strings.tr("Localizable", "onboarding.firstBody", fallback: "You can’t sign up for Netflix in the app. We know it’s a hassle. After you’re a member, you can start watching in the app. \nScroll > to learn more")
    /// Trying to join NetflixDB?
    internal static let firstTitle = Strings.tr("Localizable", "onboarding.firstTitle", fallback: "Trying to join NetflixDB?")
    /// Please go to the movieDB website and create an account
    internal static let secondBody = Strings.tr("Localizable", "onboarding.secondBody", fallback: "Please go to the movieDB website and create an account")
    /// That’s right!
    internal static let secondTitle = Strings.tr("Localizable", "onboarding.secondTitle", fallback: "That’s right!")
    /// SIGN IN
    internal static let signInButton = Strings.tr("Localizable", "onboarding.signInButton", fallback: "SIGN IN")
    /// SIGN UP
    internal static let signUpButton = Strings.tr("Localizable", "onboarding.signUpButton", fallback: "SIGN UP")
  }
  internal enum Profile {
    /// Clear Cache
    internal static let clearCacheButtonDefaultTitle = Strings.tr("Localizable", "profile.clearCacheButtonDefaultTitle", fallback: "Clear Cache")
    /// Cleared
    internal static let clearCacheButtonSuccessfullyClearedTitle = Strings.tr("Localizable", "profile.clearCacheButtonSuccessfullyClearedTitle", fallback: "Cleared")
    /// This will delete temporarily saved movies to free up space.
    /// Don't worry, your Favorites will remain safe
    internal static let clearCacheConfirmationAlertDescription = Strings.tr("Localizable", "profile.clearCacheConfirmationAlertDescription", fallback: "This will delete temporarily saved movies to free up space.\nDon't worry, your Favorites will remain safe")
    /// Clear App Cache?
    internal static let clearCacheConfirmationAlertTitle = Strings.tr("Localizable", "profile.clearCacheConfirmationAlertTitle", fallback: "Clear App Cache?")
    /// No email provided
    internal static let emailNotFoundText = Strings.tr("Localizable", "profile.emailNotFoundText", fallback: "No email provided")
    /// An error occurred while attempting to clear the cache. Please try again later.
    internal static let failedToClearCacheAlertDescription = Strings.tr("Localizable", "profile.failedToClearCacheAlertDescription", fallback: "An error occurred while attempting to clear the cache. Please try again later.")
    /// Unable to Clear Cache
    internal static let failedToClearCacheAlertTitle = Strings.tr("Localizable", "profile.failedToClearCacheAlertTitle", fallback: "Unable to Clear Cache")
    /// Log out Failed
    internal static let failedToLogoutAlertTitle = Strings.tr("Localizable", "profile.failedToLogoutAlertTitle", fallback: "Log out Failed")
    /// Log Out
    internal static let logoutButtonTitle = Strings.tr("Localizable", "profile.logoutButtonTitle", fallback: "Log Out")
    /// Are you sure you want to log out?
    /// You will need to log back in to keep watching your favorite movies
    internal static let logoutConfirmationAlertDescription = Strings.tr("Localizable", "profile.logoutConfirmationAlertDescription", fallback: "Are you sure you want to log out?\nYou will need to log back in to keep watching your favorite movies")
    /// Leaving so soon?
    internal static let logoutConfirmationAlertTitle = Strings.tr("Localizable", "profile.logoutConfirmationAlertTitle", fallback: "Leaving so soon?")
    /// Member
    internal static let memberViewText = Strings.tr("Localizable", "profile.memberViewText", fallback: "Member")
    /// Profile
    internal static let screenTitle = Strings.tr("Localizable", "profile.screenTitle", fallback: "Profile")
    /// Favorite movies
    internal static let userFavoritesCountTitle = Strings.tr("Localizable", "profile.userFavoritesCountTitle", fallback: "Favorite movies")
    /// Unknown User
    internal static let usernameNotFoundText = Strings.tr("Localizable", "profile.usernameNotFoundText", fallback: "Unknown User")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
