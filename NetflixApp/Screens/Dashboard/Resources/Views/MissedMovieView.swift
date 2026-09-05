import SwiftUI

// MARK: - MissedMovieView
struct MissedMovieView: View {
    var body: some View {
        ZStack {
            MoviePlaceholderView()
            
            Image(systemName: Constants.movieImagePlaceholderIconName)
                .font(.system(size: Constants.movieImagePlaceholderIconSize))
                .foregroundColor(.white.opacity(Constants.movieImagePlaceholderIconOpacity))
        }
    }
}

// MARK: - Constants
private extension MissedMovieView {
    enum Constants {
        static var movieImagePlaceholderIconName: String = "film"
        static var movieImagePlaceholderIconSize: CGFloat = 50
        static var movieImagePlaceholderIconOpacity: Double = 0.5
    }
}
