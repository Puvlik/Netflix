import SwiftUI

// MARK: - FeaturedMovieOverlays
struct FeaturedMovieOverlays: ViewModifier {
    let movie: MovieModel
    let isMovieFavorite: Bool
    let isLikeButtonLoading: Bool
    var onProfileTap: (() -> Void)?
    var onLikeButtonTap: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                FeaturedMovieTopBlurView(onProfileTap: onProfileTap)
            }
            .overlay(alignment: .bottom) {
                FeaturedMovieBottomBlurView(
                    featuredMovieModel: movie,
                    isMovieFavorite: isMovieFavorite,
                    isLikeButtonLoading: isLikeButtonLoading
                ) {
                    onLikeButtonTap?()
                }
                .padding(.bottom, Constants.bottomBlurOverlayBottomPadding)
            }
    }
}

// MARK: - Constants
private extension FeaturedMovieOverlays {
    enum Constants {
        static var bottomBlurOverlayBottomPadding: CGFloat = -25
    }
}
