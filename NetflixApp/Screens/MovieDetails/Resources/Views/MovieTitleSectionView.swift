import SwiftUI

// MARK: - MovieTitleSectionView
struct MovieTitleSectionView: View {
    var viewModel: MovieDetailsViewModel
    
    private var movieRuntime: String {
        guard let runtime = viewModel.movie?.runtime, runtime > .zero else {
            return Strings.MovieDetails.movieRuntimeNotFound
        }
        
        return Strings.MovieDetails.movieRuntimeText(runtime)
    }
    
    private var movieRating: String {
        guard let rating = viewModel.movie?.voteAverage, rating > .zero else {
            return Strings.MovieDetails.movieRatingNotFound
        }
        
        let sourceOfRating = Strings.Common.stringWithSpaceCharacter + Constants.movieRatingIMDBText
        return String(format: "%.1f", rating) + sourceOfRating
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.mainContentSpacing) {
            HStack(alignment: .center, spacing: Constants.movieTitleAndBadgeSpacing) {
                Text(viewModel.movie?.title ?? Strings.Movie.unknownMovieTitle)
                    .font(.title)
                    .foregroundColor(.white)
                
                Text(Constants.highResolutionBadgeTitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .modifier(
                        CustomBadgeModifier(
                            shape: RoundedRectangle(
                                cornerRadius: Constants.highResolutionBadgeCornerRadius
                            )
                        )
                    )
            }
            .bold()
            
            HStack(spacing: Constants.movieInfoHorizontalSpacing) {
                HStack(spacing: Constants.movieRuntimeAndRatingInfoSpacing) {
                    Image(systemName: Constants.clockIconSystemName)
                    Text(movieRuntime)
                }
                
                HStack(spacing: Constants.movieRuntimeAndRatingInfoSpacing) {
                    Image(systemName: Constants.starIconSystemName)
                    Text(movieRating)
                }
            }
            .font(.subheadline)
            .bold()
            .foregroundColor(.gray)
        }
    }
}

// MARK: - Constants
private extension MovieTitleSectionView {
    enum Constants {
        static var highResolutionBadgeTitle: String = "4K"
        static var movieRatingIMDBText: String = "(IMDb)"
        static var starIconSystemName: String = "star.fill"
        static var clockIconSystemName: String = "clock"
        static var mainContentSpacing: CGFloat = 12
        static var highResolutionBadgeCornerRadius: CGFloat = 8
        static var movieRuntimeAndRatingInfoSpacing: CGFloat = 4
        static var movieInfoHorizontalSpacing: CGFloat = 32
        static var movieTitleAndBadgeSpacing: CGFloat = 16
    }
}
