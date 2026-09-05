import SwiftUI

// MARK: - MoviePlaceholderView
struct MoviePlaceholderView: View {
    var body: some View {
        Color(
            red: Constants.loadingPlaceholderViewRGB,
            green: Constants.loadingPlaceholderViewRGB,
            blue: Constants.loadingPlaceholderViewRGB
        )
        .overlay(
            LinearGradient(
                colors: [
                    Color.white.opacity(.zero),
                    Color.white.opacity(Constants.gradientColoredOpacity),
                    Color.white.opacity(.zero)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

// MARK: - Constants
private extension MoviePlaceholderView {
    enum Constants {
        static var loadingPlaceholderViewRGB: CGFloat = 0.15
        static var gradientColoredOpacity: Double = 0.3
    }
}
