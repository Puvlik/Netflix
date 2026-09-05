import SwiftUI

// MARK: - FavoritesTabView
struct FavoritesTabView: View {
    @Bindable var viewModel: FavoritesTabViewModel
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            switch viewModel.viewState {
            case .loading:
                NetflixLoaderView(size: Constants.noDataLoaderViewSize)
                    .frame(maxHeight: .infinity)
                    .transition(
                        .opacity.animation(
                            .easeInOut(
                                duration: Constants.loaderTransitionDuration
                            )
                        )
                    )
            case .loaded:
                if viewModel.favoriteMovies.isEmpty {
                    EmptyFavouritesView {
                        viewModel.openComingSoonToDiscoverMovies()
                    }
                } else {
                    favouriteMoviesList
                        .padding(.bottom, Constants.favoriteMoviesListBottomPadding)
                }
            case .fetchErrorAlert:
                Color.clear
            case .fetchFailedView:
                FavoritesNotLoadedView {
                    viewModel.fetchFavoriteMovies()
                }
            }
        }
        .modifier(NetworkBannerModifier())
        .onAppear {
            viewModel.fetchFavoriteMovies()
        }
        .alert(
            viewModel.coreDataActiveError?.alertTitle ?? Strings.CoreData.commonErrorTitle,
            isPresented: $viewModel.showCoreDataAlert
        ) {
            Button(Strings.Common.okButtonTitle, role: .cancel) {
                if viewModel.coreDataActiveError == .moviesFetchFailed {
                    viewModel.viewState = .fetchFailedView
                }
                
                if let restore = viewModel.movieToRestore {
                    viewModel.favoriteMovies.insert(restore.movie, at: restore.index)
                    viewModel.movieToRestore = nil
                }
                
                viewModel.coreDataActiveError = nil
            }
        } message: {
            Text(viewModel.coreDataActiveError?.errorDescription ?? Strings.CoreData.commonErrorDescription)
        }
    }
    
    // MARK: - Private views
    private var favouriteMoviesList: some View {
        List {
            ForEach(viewModel.favoriteMovies) { movie in
                FavoriteMovieCardView(movie: movie) { id in
                    viewModel.openMovieDetails(for: id)
                }
                .listRowInsets(
                    EdgeInsets(
                        top: .zero,
                        leading: Constants.movieCellHorizontalInset,
                        bottom: .zero,
                        trailing: Constants.movieCellHorizontalInset
                    )
                )
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.removeFromFavorites(movie: movie)
                    } label: {
                        Text(Strings.Common.deleteButtonTitle)
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .listRowSpacing(Constants.moviesListRowSpacing)
        .padding(.top, Constants.moviesListTopPadding)
        .animation(.default, value: viewModel.favoriteMovies)
    }
}

// MARK: - Constants
private extension FavoritesTabView {
    enum Constants {
        static var favoriteMoviesListBottomPadding: CGFloat = 8
        static var movieCellHorizontalInset: CGFloat = 16
        static var moviesListRowSpacing: CGFloat = 16
        static var moviesListTopPadding: CGFloat = 8
        static var noDataLoaderViewSize: CGFloat = 200
        static var loaderTransitionDuration: TimeInterval = 0.4
    }
}
