import SwiftUI

// MARK: - ComingSoonTabView
struct ComingSoonTabView: View {
    @Bindable var viewModel: ComingSoonTabViewModel
    
    private let gridColumns = Array(
        repeating: GridItem(
            .flexible(),
            spacing: Constants.gridColumnsHorizontalSpacing
        ),
        count: Constants.gridColumnsCount
    )
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                MoviesSearchBar(searchText: $viewModel.searchText)
                
                ZStack {
                    if viewModel.showLoaderWhenDataLoading {
                        NetflixLoaderView(size: Constants.noDataLoaderViewSize)
                            .frame(maxHeight: .infinity)
                            .transition(.opacity.animation(.easeInOut(duration: Constants.loaderTransitionDuration)))
                    } else {
                        mainContentView
                            .transition(.opacity.animation(.easeInOut(duration: Constants.loaderTransitionDuration)))
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, Constants.mainContentTopPadding)
        }
        .modifier(NetworkBannerModifier())
        .onAppear {
            viewModel.fetchComingSoonMovies()
        }
        .task(id: viewModel.searchText) {
            await viewModel.performMoviesSearchWithQuery()
        }
        .alert(
            Strings.ComingSoon.failedToLoadComingSoonAlertTitle,
            isPresented: $viewModel.showPaginationFetchFailedAlert
        ) {
            Button(Strings.Common.tryAgainButtonTitle) {
                viewModel.retryLoadNextMoviePages()
            }
            
            Button(Strings.Common.okButtonTitle, role: .cancel) {
                viewModel.paginationErrorMessage = nil
            }
        } message: {
            Text(viewModel.paginationErrorMessage ?? Strings.ComingSoon.failedToLoadComingSoonErrorText)
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
    
    private var emptyMoviesSearchView: some View {
        VStack(spacing: Constants.emptySearchViewInnerSpacing) {
            Image(systemName: Constants.magnifyingGlassIconSystemName)
                .font(.largeTitle)
            
            Text(Strings.ComingSoon.emptySearchListText(viewModel.searchText))
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.white)
        .padding(.horizontal)
    }
    
    private var moviesGridView: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: Constants.columnInnerSpacing) {
                ForEach(viewModel.tempMoviesArray) { movie in
                    ComingSoonMovieCard(movie: movie) { id in
                        viewModel.openMovieDetails(for: id)
                    }
                    .onAppear {
                        if movie.id == viewModel.tempMoviesArray.last?.id {
                            viewModel.loadNextMoviePages()
                        }
                    }
                }
            }
            .animation(.easeInOut, value: viewModel.searchText)
        }
        .padding(.horizontal, Constants.movieCardsGridHorizontalPadding)
        .padding(.bottom, Constants.moviesGridBittonPadding)
        .scrollIndicators(.hidden)
    }
    
    // MARK: - View Builders
    
    @ViewBuilder
    private var mainContentView: some View {
        if viewModel.isMoviesFetchFailed && viewModel.tempMoviesArray.isEmpty {
            OfflineEmptyGridView(errorMessage: viewModel.comingSoonErrorMessage) {
                viewModel.retryFailedFetch()
            }
        } else if viewModel.isMoviesSearchArrayEmpty {
            emptyMoviesSearchView
        } else {
            moviesGridView
        }
    }
}

// MARK: - Constants
private extension ComingSoonTabView {
    enum Constants {
        static var mainContentTopPadding: CGFloat = 8
        static var movieCardsGridHorizontalPadding: CGFloat = 8
        static var columnInnerSpacing: CGFloat = 8
        static var gridColumnsHorizontalSpacing: CGFloat = 8
        static var gridColumnsCount: Int = 3
        static var moviesGridBittonPadding: CGFloat = 8
        static var magnifyingGlassIconSystemName: String = "magnifyingglass"
        static var emptySearchViewInnerSpacing: CGFloat = 16
        static var noDataLoaderViewSize: CGFloat = 200
        static var loaderTransitionDuration: TimeInterval = 0.4
    }
}
