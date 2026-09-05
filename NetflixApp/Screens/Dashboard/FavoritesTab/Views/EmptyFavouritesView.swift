import SwiftUI

struct EmptyFavouritesView: View {
    var discoverMoviesTapped: (() -> Void)?
    
    var body: some View {
        VStack(spacing: Constants.contentStackSpacing) {
            Image(systemName: Constants.hearthIconSystemName)
                .font(.system(size: Constants.hearthIconFontSize))
            
            Text(Strings.Favourites.emptyFavouriteMoviesListTitle)
                .font(.title)
            
            Text(Strings.Favourites.emptyFavouriteMoviesListDescription)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Button {
                discoverMoviesTapped?()
            } label: {
                Text(Strings.Favourites.discoverMoviesButtonTitle)
                    .padding()
                    .font(.headline)
                    .background(Assets.Colors.netflixMainRed.swiftUIColor)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.discoverMoviesButtonCornerRadius))
            }
        }
        .padding(.horizontal, Constants.contentHorizontalPadding)
        .foregroundColor(.white)
        .fontWeight(.bold)
    }
}

// MARK: - Constants
private extension EmptyFavouritesView {
    enum Constants {
        static var contentStackSpacing: CGFloat = 16
        static var contentHorizontalPadding: CGFloat = 32
        static var hearthIconFontSize: CGFloat = 80
        static var hearthIconSystemName: String = "heart.slash.fill"
        static var discoverMoviesButtonCornerRadius: CGFloat = 16
    }
}
