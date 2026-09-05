import SwiftUI

// MARK: - FeaturedMovieBottomBlurView
struct FeaturedMovieBottomBlurView: View {
    let featuredMovieModel: MovieModel
    let isMovieFavorite: Bool
    let isLikeButtonLoading: Bool
    var onLikeButtonTap: (() -> Void)?
    
    @State private var tapTrigger = false
    
    private var likeButtonState: (icon: String, text: String) {
        let iconName = isMovieFavorite ? Constants.filledLikeButtonIconSystemName : Constants.likeButtonIconSystemName
        let buttonText = isMovieFavorite ? Strings.HomeTab.unlikeButtonTitle : Strings.HomeTab.likeButtonTitle
        
        return (iconName, buttonText)
    }
    
    var body: some View {
        VStack(spacing: Constants.viewStackSpacing) {
            Group {
                Text(featuredMovieModel.displayName)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .allowsHitTesting(false)
                
                FeaturedMovieTagsView(movieTags: featuredMovieModel.genreTitles)
                    .allowsHitTesting(false)
            }
            .padding(.horizontal, Constants.movieTitleGroupHorizontalPadding)
            
            ZStack {
                PlayMovieTrailerButtonView()

                HStack {
                    Button {
                        guard !isLikeButtonLoading else { return }
                        tapTrigger.toggle()
                        onLikeButtonTap?()
                    } label: {
                        VStack(spacing: Constants.likeButtonStackSpacing) {
                            Image(systemName: likeButtonState.icon)
                                .font(.title)
                                .fontWeight(.bold)
                                .symbolEffect(.bounce, value: tapTrigger)
                            Text(likeButtonState.text)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .frame(width: Constants.likeButtonTextWidth)
                        }
                        .foregroundColor(.white)
                    }

                    Spacer()
                }
            }
            .padding(.top)
            .padding(.horizontal, Constants.buttonsStackHorizontalPadding)
        }
        .padding(.top, Constants.viewTopPadding)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(
                        color: .black.opacity(Constants.gradientStartOpacity),
                        location: Constants.gradientStartLocation
                    ),
                    Gradient.Stop(color: .clear, location: Constants.gradientEndLocation)
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            .allowsHitTesting(false)
        )
    }
}

// MARK: - Constants
private extension FeaturedMovieBottomBlurView {
    enum Constants {
        static var likeButtonStackSpacing: CGFloat = 3
        static var likeButtonTextWidth: CGFloat = 50
        static var likeButtonIconSystemName: String = "heart"
        static var filledLikeButtonIconSystemName: String = "heart.fill"
        static var buttonsStackHorizontalPadding: CGFloat = 48
        static var movieTitleGroupHorizontalPadding: CGFloat = 8
        static var viewTopPadding: CGFloat = 64
        static var viewStackSpacing: CGFloat = 12
        static var gradientStartOpacity: Double = 0.65
        static var gradientStartLocation: CGFloat = 0.85
        static var gradientEndLocation: CGFloat = 1.0
    }
}
