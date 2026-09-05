import SwiftUI

// MARK: - MovieLargeImageSectionView
struct MovieLargeImageSectionView: View {
    var imageURL: URL?
    var isMovieFavorite: Bool
    var dismiss: (() -> Void)?
    var onLikeButtonTap: (() -> Void)?
    
    @State private var tapTrigger = false
    
    var body: some View {
        ZStack(alignment: .top) {
            CachedImageView(url: imageURL) { phase in
                switch phase {
                case .empty:
                    MovieImageLoadingView(loaderSize: Constants.loaderIndicatorSize)
                    
                case .success(let image):
                    Color.clear
                        .overlay(
                            image
                                .resizable()
                                .scaledToFill()
                        )
                    
                case .failure:
                    MissedMovieView()
                }
            }
            .clipped()
            .containerRelativeFrame(.vertical) { containerHeight, _ in
                containerHeight * Constants.movieImageHeightMultiplier
            }
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black]),
                    startPoint: .center,
                    endPoint: .bottom
                )
            )

            actionsTopView
        }
        .overlay(alignment: .bottom) {
            PlayMovieTrailerButtonView()
                .padding(.bottom, Constants.playTrailerButtonBottomPadding)
        }
    }
    
    private var actionsTopView: some View {
        HStack {
            Button {
                dismiss?()
            } label: {
                Image(systemName: Constants.dismissImageSystemName)
                    .font(.title)
                    .padding(Constants.dismissButtonPadding)
                    .background(Color.black.opacity(Constants.dismissButtonBackgroundOpacity))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Button {
                tapTrigger.toggle()
                onLikeButtonTap?()
            } label: {
                let iconName = isMovieFavorite ? Constants.filledLikeIconSystemName : Constants.likeIconSystemName
                Image(systemName: iconName)
                    .font(.largeTitle)
                    .foregroundColor(isMovieFavorite ? .red : .white)
                    .shadow(
                        color: isMovieFavorite ? .clear : .black.opacity(Constants.likeButtonShadowOpacity),
                        radius: isMovieFavorite ? .zero : Constants.likeButtonShadowRadius,
                        x: .zero, y: .zero
                    )
                    .symbolEffect(.bounce, value: tapTrigger)
            }
        }
        .bold()
        .foregroundColor(.white)
        .padding(.horizontal)
        .padding(.top, Constants.buttonsTopPadding)
    }
}

// MARK: - Constants
private extension MovieLargeImageSectionView {
    enum Constants {
        static var stateTransactionDuration: TimeInterval = 0.25
        static var loaderIndicatorSize: CGFloat = 60
        static var buttonsTopPadding: CGFloat = 8
        static var playTrailerButtonBottomPadding: CGFloat = 32
        static var movieImageHeightMultiplier: CGFloat = 0.4
        static var dismissImageSystemName: String = "chevron.left"
        static var dismissButtonPadding: CGFloat = 14
        static var dismissButtonBackgroundOpacity: Double = 0.4
        static var likeButtonShadowOpacity: Double = 1
        static var likeButtonShadowRadius: CGFloat = 7
        static var likeIconSystemName: String = "heart"
        static var filledLikeIconSystemName: String = "heart.fill"
    }
}
