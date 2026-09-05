import SwiftUI

// MARK: - RelatedMovieCard
struct RelatedMovieCard: View {
    let movie: MovieModel
    var openMovieDetails: ((_ movieId: Int) -> Void)?

    private var releaseYearAsStringIfExists: String {
        let year = movie.releaseDate.extractReleaseYearAsString()
        return year.isEmpty ? "" : "(\(year))"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.contentStackSpacing) {
            CachedImageView(url: movie.backdropURL(size: .w300)) { phase in
                switch phase {
                case .empty:
                    MovieImageLoadingView(loaderSize: Constants.loaderIndicatorSize)
                    
                case .success(let image):
                    Color.clear
                        .overlay(
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .modifier(AdultContentModifier(isAdult: movie.isAdult))
                        )
                    
                case .failure:
                    MissedMovieView()
                }
            }
            .frame(height: Constants.movieImageHeight)
            .clipShape(RoundedRectangle(cornerRadius: Constants.movieImageCornerRadius))
            
            (
                Text(movie.title ?? Strings.Movie.unknownMovieTitle)
                .font(.subheadline)
                .bold()
                .foregroundColor(.white)
                + Text(Strings.Common.stringWithSpaceCharacter + releaseYearAsStringIfExists)
                .font(.subheadline)
                .bold()
                .foregroundColor(.gray)
            )
            .lineLimit(Constants.movieInformationLinesLimit, reservesSpace: true)
            .truncationMode(.tail)
            .multilineTextAlignment(.leading)
        }
        .frame(width: Constants.movieImageWidth)
        .onTapGesture {
            openMovieDetails?(movie.id)
        }
    }
}

// MARK: - Constants
private extension RelatedMovieCard {
    enum Constants {
        static var contentStackSpacing: CGFloat = 8
        static var movieImageHeight: CGFloat = 110
        static var movieImageWidth: CGFloat = 150
        static var movieImageCornerRadius: CGFloat = 16
        static var movieInformationLinesLimit: Int = 2
        static var loaderIndicatorSize: CGFloat = 30
        static var stateTransactionDuration: TimeInterval = 0.25
    }
}
