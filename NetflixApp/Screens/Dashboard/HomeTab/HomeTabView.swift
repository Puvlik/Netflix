import SwiftUI

// MARK: - HomeTabView
struct HomeTabView: View {
    @Bindable var viewModel: HomeTabViewModel
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ZStack {
                if viewModel.showLoaderWhenDataLoading {
                    NetflixLoaderView(size: Constants.noDataLoaderViewSize)
                        .frame(maxHeight: .infinity)
                        .transition(.opacity.animation(.easeInOut(duration: Constants.loaderTransitionDuration)))
                } else {
                    homePageMainContent
                        .transition(.opacity.animation(.easeInOut(duration: Constants.loaderTransitionDuration)))
                }
            }
        }
        .modifier(NetworkBannerModifier())
        .onAppear {
            viewModel.fetchPopularMovies()
            viewModel.refreshFeaturedMovieFavoriteState()
        }
        .alert(
            Strings.Alamofire.failedToLoadMoviesAlertTitle,
            isPresented: $viewModel.showFetchFailedAlert
        ) {
            Button(Strings.Common.tryAgainButtonTitle) {
                viewModel.fetchFailedErrorMessage = nil
                viewModel.fetchPopularMovies()
            }
        } message: {
            Text(viewModel.fetchFailedErrorMessage ?? Strings.HomeTab.moviesUnavailableErrorText)
        }
        .alert(
            Strings.HomeTab.failedToLoadPopularMoviesAlertTitle,
            isPresented: $viewModel.showPopularMoviesFetchFailedAlert
        ) {
            Button(Strings.Common.tryAgainButtonTitle) {
                viewModel.retryFetchPopularMovies()
            }
            
            Button(Strings.Common.okButtonTitle, role: .cancel) {
                viewModel.popularMoviesFetchFailedErrorMessage = nil
            }
        } message: {
            Text(viewModel.popularMoviesFetchFailedErrorMessage ?? Strings.HomeTab.moviesUnavailableErrorText)
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
    
    // MARK: - Private views
    private var loadingFeaturedMovie: some View {
        MovieImageLoadingView(loaderSize: Constants.loadingAnimationViewSize)
            .modifier(FeaturedMovieHeightFrame())
            .transition(.opacity)
    }
    
    private var featuredMovieImageMissed: some View {
        MissedMovieView()
            .clipShape(RoundedRectangle(cornerRadius: Constants.movieCardCornerRadius))
            .modifier(FeaturedMovieHeightFrame())
            .overlay(alignment: .top) {
                FeaturedMovieTopBlurView(onProfileTap: {
                    viewModel.openProfilePageTapped()
                })
            }
    }
    
    // MARK: - View Builders

    @ViewBuilder
    private var homePageMainContent: some View {
        if !viewModel.isMoviesFetchFailed {
            VStack(spacing: Constants.homeTabStackSpacing) {
                featuredMovieSection
                PopularMoviesView(viewModel: viewModel)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .animation(
                .easeInOut(duration: Constants.stateTransactionDuration),
                value: viewModel.isLoading
            )
        }
    }
    
    @ViewBuilder
    private var featuredMovieSection: some View {
        if viewModel.isLoading {
            loadingFeaturedMovie
        } else if let movie = viewModel.tempFeaturedMovie {
            FeaturedMovieCardView(
                movie: movie,
                isMovieFavorite: viewModel.isFeaturedMovieFavorite,
                isLikeButtonLoading: viewModel.isLikeButtonLoading,
                onProfileTap: {
                    viewModel.openProfilePageTapped()
                }, onLikeButtonTap: {
                    viewModel.toggleFeaturedMovieFavoriteState()
                }, openMovieDetails: { id in
                    viewModel.openMovieDetails(for: id)
                }
            )
            .transition(.opacity)
        } else {
            featuredMovieImageMissed
        }
    }
}

// MARK: - Constants
private extension HomeTabView {
    enum Constants {
        static var homeTabStackSpacing: CGFloat = 42
        static var noDataLoaderViewSize: CGFloat = 200
        static var loaderTransitionDuration: TimeInterval = 0.3
        static var loadingAnimationViewSize: CGFloat = 75
        static var stateTransactionDuration: TimeInterval = 0.25
        static var movieCardCornerRadius: CGFloat = 16
    }
}
