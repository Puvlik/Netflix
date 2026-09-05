import SwiftUI

// MARK: - ComingSoonMovieCard
struct ComingSoonMovieCard: View {
    let movie: MovieModel
    var openMovieDetails: ((_ movieId: Int) -> Void)?
    
    var body: some View {
        Color.clear
            .aspectRatio(Constants.aspectRatioModifier, contentMode: .fit)
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
            .contentShape(Rectangle())
            .onTapGesture {
                openMovieDetails?(movie.id)
            }
    }
}

// MARK: - Constants
private extension ComingSoonMovieCard {
    enum Constants {
        static var aspectRatioModifier: CGFloat = 2.0 / 3.0
        static var loaderIndicatorSize: CGFloat = 30
        static var cardCornerRadius: CGFloat = 12
        static var stateTransactionDuration: TimeInterval = 0.25
    }
}
