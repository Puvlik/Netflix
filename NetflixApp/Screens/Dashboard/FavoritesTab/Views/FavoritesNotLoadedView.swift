import SwiftUI

struct FavoritesNotLoadedView: View {
    var reloadTapped: (() -> Void)?
    
    var body: some View {
        VStack(spacing: Constants.contentStackSpacing) {
            Image(systemName: Constants.arrowIconSystemName)
                .font(.system(size: Constants.arrowIconFontSize))
            
            Text(Strings.Favourites.fetchingFailedTitle)
                .font(.title)
            
            Text(Strings.Favourites.fetchingFailedDescription)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Button {
                reloadTapped?()
            } label: {
                Text(Strings.Favourites.reloadButtonTitle)
                    .font(.headline)
                    .frame(width: Constants.reloadButtonWidth)
                    .padding()
                    .background(Assets.Colors.netflixMainRed.swiftUIColor)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.reloadButtonCornerRadius))
            }
        }
        .padding(.horizontal, Constants.contentHorizontalPadding)
        .foregroundColor(.white)
        .fontWeight(.bold)
    }
}

// MARK: - Constants
private extension FavoritesNotLoadedView {
    enum Constants {
        static var contentStackSpacing: CGFloat = 16
        static var arrowIconSystemName: String = "square.and.arrow.down.badge.xmark"
        static var arrowIconFontSize: CGFloat = 80
        static var contentHorizontalPadding: CGFloat = 32
        static var reloadButtonCornerRadius: CGFloat = 16
        static var reloadButtonWidth: CGFloat = 100
    }
}
