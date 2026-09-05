import SwiftUI

// MARK: - FavoriteMovieCardView
struct FavoriteMovieCardView: View {
    let movie: MovieModel
    var openMovieDetails: ((_ movieId: Int) -> Void)?
    
    var body: some View {
        CachedImageView(url: movie.backdropURL(size: .w780)) { phase in
            switch phase {
            case .empty:
                MovieImageLoadingView(loaderSize: Constants.loaderIndicatorSize)
                
            case .success(let image):
                Color.clear
                    .overlay(
                        image
                            .resizable()
                            .scaledToFill()
                            .modifier(AdultContentModifier(isAdult: movie.isAdult))
                    )

            case .failure:
                MissedMovieView()
            }
        }
        .frame(height: Constants.movieCardHeight)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: Constants.movieCardCornerRadius))
        .transition(.opacity)
        .onTapGesture {
            openMovieDetails?(movie.id)
        }
    }
}

// MARK: - Constants
private extension FavoriteMovieCardView {
    enum Constants {
        static var stateTransactionDuration: TimeInterval = 0.25
        static var loaderIndicatorSize: CGFloat = 30
        static var movieCardCornerRadius: CGFloat = 24
        static var movieCardHeight: CGFloat = 200
    }
}
