import SwiftUI

// MARK: - OfflineEmptyGridView
struct OfflineEmptyGridView: View {
    var errorMessage: String?
    var reloadButtonTap: (() -> Void)?
    
    var body: some View {
        VStack(spacing: Constants.offlineViewContentStackSpacing) {
            Image(systemName: Constants.wifiIconSystemName)
                .font(.system(size: Constants.wifiIconFontSize))
            
            Text(Strings.Alamofire.failedToLoadMoviesAlertTitle)
                .font(.title2)
            
            Text(errorMessage ?? Strings.Alamofire.checkInternetConnectionError)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Button {
                reloadButtonTap?()
            } label: {
                Text(Strings.Favourites.reloadButtonTitle)
                    .font(.headline)
                    .frame(width: Constants.reloadButtonWidth)
                    .padding()
                    .background(Assets.Colors.netflixMainRed.swiftUIColor)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.reloadButtonCornerRadius))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, Constants.offlineViewHorizontalPadding)
        .foregroundColor(.white)
        .fontWeight(.bold)
    }
}

// MARK: - Constants
private extension OfflineEmptyGridView {
    enum Constants {
        static var offlineViewContentStackSpacing: CGFloat = 16
        static var reloadButtonWidth: CGFloat = 100
        static var reloadButtonCornerRadius: CGFloat = 16
        static var offlineViewHorizontalPadding: CGFloat = 32
        static var wifiIconSystemName: String = "wifi.slash"
        static var wifiIconFontSize: CGFloat = 80
    }
}
