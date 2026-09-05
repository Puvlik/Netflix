import SwiftUI

// MARK: - RelatedMovieCard
struct RelatedMoviesView: View {
    var viewModel: MovieDetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.relatedMoviesSectionSpacing) {
            Text(Strings.MovieDetails.relatedMoviesSectionTitle)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: Constants.relatedMoviesCellsSpacing) {
                    ForEach(viewModel.tempRecommendationsArray) { movie in
                        RelatedMovieCard(movie: movie) { id in
                            viewModel.openRelatedMovieDetails(id: id)
                        }
                        .onAppear {
                            if movie.id == viewModel.tempRecommendationsArray.last?.id {
                                viewModel.loadNextRecommendationPages()
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Constants
private extension RelatedMoviesView {
    enum Constants {
        static var relatedMoviesSectionSpacing: CGFloat = 16
        static var relatedMoviesCellsSpacing: CGFloat = 16
    }
}
