import SwiftUI

// MARK: - MovieDetailsView
struct MovieDetailsView: View {
    @Bindable var viewModel: MovieDetailsViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()

            ZStack {
                if viewModel.showLoaderWhenDataLoading {
                    NetflixLoaderView(size: Constants.noDataLoaderViewSize)
                        .frame(maxHeight: .infinity)
                        .transition(
                            .opacity.animation(
                                .easeInOut(
                                    duration: Constants.loaderTransitionDuration
                                )
                            )
                        )
                } else {
                    fullMovieDetailsView
                        .transition(.opacity.animation(.easeInOut(duration: Constants.loaderTransitionDuration)))
                }
            }
            .frame(maxHeight: .infinity)
        }
        .modifier(NetworkBannerModifier())
        .onAppear {
            viewModel.fetchMovieDetails()
        }
        .alert(
            Strings.MovieDetails.failedToLoadMoviesDetailsAlertTitle,
            isPresented: $viewModel.showMovieDetailsFetchFailedAlert
        ) {
            Button(Strings.Common.tryAgainButtonTitle) {
                viewModel.movieDetailsErrorMessage = nil
                viewModel.fetchMovieDetails()
            }
        } message: {
            Text(viewModel.movieDetailsErrorMessage ?? Strings.MovieDetails.failedToLoadMoviesDetailsErrorText)
        }
        .alert(
            Strings.MovieDetails.failedToLoadRelatedMoviesAlertTitle,
            isPresented: $viewModel.showRelatedMoviesFetchFailedAlert
        ) {
            Button(Strings.Common.tryAgainButtonTitle) {
                viewModel.retryLoadNextRecommendationPages()
            }
            
            Button(Strings.Common.okButtonTitle, role: .cancel) {
                viewModel.relatedMoviesErrorMessage = nil
            }
        } message: {
            Text(viewModel.relatedMoviesErrorMessage ?? Strings.MovieDetails.failedToLoadRelatedMoviesErrorText)
        }
        .alert(
            viewModel.coreDataActiveError?.alertTitle ?? Strings.CoreData.commonErrorTitle,
            isPresented: $viewModel.showCoreDataAlert,
        ) {
            Button(Strings.Common.okButtonTitle, role: .cancel) {
                viewModel.coreDataActiveError = nil
            }
        } message: {
            Text(viewModel.coreDataActiveError?.errorDescription ?? Strings.CoreData.commonErrorDescription)
        }
    }
    
    // MARK: - View Builders
    @ViewBuilder
    private var fullMovieDetailsView: some View {
        if !viewModel.isMovieFetchFailed {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    MovieLargeImageSectionView(
                        imageURL: viewModel.movie?.backdropURL(size: .w780),
                        isMovieFavorite: viewModel.isMovieFavorite,
                        dismiss: {
                            viewModel.closeMovieDetails()
                        },
                        onLikeButtonTap: {
                            viewModel.toggleMovieFavoriteState()
                        }
                    )
                    
                    movieDetailedInformationBlock
                }
            }
        }
    }
    
    // MARK: - Private views
    private var movieDetailedInformationBlock: some View {
        VStack(alignment: .leading, spacing: Constants.movieDetailedInformationSpacing) {
            MovieTitleSectionView(viewModel: viewModel)
            
            Divider()
                .background(Assets.Colors.movieDetailsDivider.swiftUIColor)

            MovieInformationSectionView(viewModel: viewModel)
            
            Divider()
                .background(Assets.Colors.movieDetailsDivider.swiftUIColor)
            
            if let movieOverview = viewModel.movie?.overview, !movieOverview.isEmpty {
                MovieSynopsisSectionExpandableView(movieDescription: movieOverview)
            }
            
            if !viewModel.tempRecommendationsArray.isEmpty {
                RelatedMoviesView(viewModel: viewModel)
            }
        }
        .padding(.top)
        .padding(.horizontal)
    }
}

// MARK: - Constants
private extension MovieDetailsView {
    enum Constants {
        static var movieDetailedInformationSpacing: CGFloat = 20
        static var noDataLoaderViewSize: CGFloat = 200
        static var loaderTransitionDuration: TimeInterval = 0.4
    }
}
