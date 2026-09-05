import SwiftUI

// MARK: - PopularMoviesView
struct PopularMoviesView: View {
    @Bindable var viewModel: HomeTabViewModel
    
    var body: some View {
        if !viewModel.tempPopularMovies.isEmpty {
            VStack(alignment: .leading, spacing: Constants.sectionStackSpacing) {
                Text(Strings.HomeTab.popularMoviesSectionTitle)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: Constants.moviesCarouselSpacing) {
                        ForEach(viewModel.tempPopularMovies) { movie in
                            PopularMovieCardView(movie: movie) { id in
                                viewModel.openMovieDetails(for: id)
                            }
                            .onAppear {
                                if movie.id == viewModel.tempPopularMovies.last?.id {
                                    viewModel.fetchPopularMovies(isPaginating: true)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Constants.moviesCarouselHorizontalPadding)
                }
            }
            .padding(.bottom, Constants.sectionBottomPadding)
        }
    }
}

// MARK: - Constants
private extension PopularMoviesView {
    enum Constants {
        static var sectionStackSpacing: CGFloat = 6
        static var sectionBottomPadding: CGFloat = 4
        static var moviesCarouselSpacing: CGFloat = 8
        static var moviesCarouselHorizontalPadding: CGFloat = 8
    }
}
