import SwiftUI

// MARK: - FeaturedMovieCardView
struct FeaturedMovieCardView: View {
    let movie: MovieModel
    let isMovieFavorite: Bool
    let isLikeButtonLoading: Bool
    var onProfileTap: (() -> Void)?
    var onLikeButtonTap: (() -> Void)?
    var openMovieDetails: ((_ movieId: Int) -> Void)?
    
    var body: some View {
        CachedImageView(url: movie.posterURL(size: .w780)) { phase in
            switch phase {
            case .empty:
                MovieImageLoadingView(loaderSize: Constants.loadingAnimationViewSize)
            case .success(let image):
                Color.clear
                    .overlay(
                        image
                            .resizable()
                            .scaledToFill()
                            .modifier(
                                AdultContentModifier(
                                    isAdult: movie.isAdult,
                                    scale: Constants.blurScale
                                )
                            )
                    )
            case .failure:
                MissedMovieView()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Constants.movieCardCornerRadius))
        .clipped()
        .modifier(
            FeaturedMovieOverlays(
                movie: movie,
                isMovieFavorite: isMovieFavorite,
                isLikeButtonLoading: isLikeButtonLoading,
                onProfileTap: onProfileTap,
                onLikeButtonTap: onLikeButtonTap
            )
        )
        .onTapGesture {
            openMovieDetails?(movie.id)
        }
        .modifier(FeaturedMovieHeightFrame())
        .transition(.opacity)
    }
}

// MARK: - Constants
private extension FeaturedMovieCardView {
    enum Constants {
        static var loadingAnimationViewSize: CGFloat = 75
        static var movieCardCornerRadius: CGFloat = 16
        static var stateTransactionDuration: TimeInterval = 0.25
        static var blurScale: CGFloat = 1.5
    }
}
