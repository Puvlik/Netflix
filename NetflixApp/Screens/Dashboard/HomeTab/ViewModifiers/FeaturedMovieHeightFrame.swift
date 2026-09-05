import SwiftUI

// MARK: - FeaturedMovieHeightFrame
struct FeaturedMovieHeightFrame: ViewModifier {
    func body(content: Content) -> some View {
        content
            .containerRelativeFrame(.vertical) { containerHeight, _ in
                containerHeight * Constants.imageHeightMultiplier
            }
    }
}

// MARK: - Constants
private extension FeaturedMovieHeightFrame {
    enum Constants {
        static var imageHeightMultiplier: CGFloat = 0.65
    }
}
