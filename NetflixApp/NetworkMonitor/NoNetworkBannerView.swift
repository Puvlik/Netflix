import SwiftUI

struct NoNetworkBannerView: View {
    var body: some View {
        Image(systemName: Constants.wifiIconSystemName)
            .font(.title3.bold())
            .foregroundColor(.white)
            .padding(Constants.wifiIconSidePadding)
            .background(Assets.Colors.netflixMainRed.swiftUIColor.opacity(Constants.bannerBackgroundOpacity))
            .clipShape(Circle())
    }
}

// MARK: - Constants
private extension NoNetworkBannerView {
    enum Constants {
        static var wifiIconSystemName: String = "wifi.slash"
        static var wifiIconSidePadding: CGFloat = 12
        static var bannerBackgroundOpacity: Double = 0.9
    }
}
