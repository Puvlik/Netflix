import SwiftUI

// MARK: - MovieInformationSectionView
struct MovieInformationSectionView: View {
    var viewModel: MovieDetailsViewModel
    
    private var userFriendlyReleaseDate: String {
        guard let movie = viewModel.movie else {
            return Strings.MovieDetails.movieReleaseDateNotFound
        }
        
        return movie.releaseDate.transformToUserFriendlyString()
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: Constants.mainContentSpacing) {
            VStack(alignment: .leading, spacing: Constants.informationBlockSpacing) {
                Text(Strings.MovieDetails.infoSectionReleaseDateTitle)
                    .font(.title3)
                    .foregroundColor(.white)
                
                Text(userFriendlyReleaseDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            if let genres = viewModel.movie?.genreTitles, !genres.isEmpty {
                VStack(alignment: .leading, spacing: Constants.informationBlockSpacing) {
                    Text(Strings.MovieDetails.infoSectionGenreTitle)
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    BadgeFlowLayout {
                        ForEach(genres, id: \.self) { genre in
                            Text(genre)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.horizontal, Constants.movieGenreBadgeHorizontalPadding)
                                .modifier(
                                    CustomBadgeModifier(
                                        shape: Capsule()
                                    )
                                )
                        }
                    }
                }
            }
        }
        .bold()
    }
}

// MARK: - Constants
private extension MovieInformationSectionView {
    enum Constants {
        static var mainContentSpacing: CGFloat = 48
        static var informationBlockSpacing: CGFloat = 8
        static var movieGenreBadgeHorizontalPadding: CGFloat = 4
    }
}
