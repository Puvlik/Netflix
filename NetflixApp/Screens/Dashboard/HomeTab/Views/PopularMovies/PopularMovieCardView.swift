import SwiftUI

// MARK: - PopularMovieCardView
struct PopularMovieCardView: View {
    let movie: MovieModel
    var openMovieDetails: ((_ movieId: Int) -> Void)?
    
    var body: some View {
        Color.clear
            .containerRelativeFrame(.horizontal) { containerWidth, _ in
                containerWidth * Constants.imageWidthMultiplier
            }
            .overlay {
                CachedImageView(url: movie.posterURL(size: .w185)) { phase in
                    switch phase {
                    case .empty:
                        MovieImageLoadingView(loaderSize: Constants.loaderIndicatorSize)
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .modifier(AdultContentModifier(isAdult: movie.isAdult))
                        
                    case .failure:
                        MissedMovieView()
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: Constants.cardCornerRadius))
            .transition(.opacity)
            .onTapGesture {
                openMovieDetails?(movie.id)
            }
    }
}

// MARK: - Constants
private extension PopularMovieCardView {
    enum Constants {
        static var loaderIndicatorSize: CGFloat = 30
        static var imageWidthMultiplier: CGFloat = 0.28
        static var cardCornerRadius: CGFloat = 12
        static var stateTransactionDuration: TimeInterval = 0.25
    }
}
