import SwiftUI

// MARK: - CustomBadgeModifier
struct CustomBadgeModifier<T: Shape>: ViewModifier {
    let shape: T

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, Constants.contentHorizontalPadding)
            .padding(.vertical, Constants.contentVerticalPadding)
            .background(Assets.Colors.movieBadgeBackground.swiftUIColor)
            .clipShape(shape)
            .overlay(
                shape.stroke(
                    Assets.Colors.movieBadgeBorder.swiftUIColor,
                    lineWidth: Constants.badgeBorderWidth
                )
            )
    }
}

// MARK: - Constants
private extension CustomBadgeModifier {
    enum Constants {
        static var contentHorizontalPadding: CGFloat { 10 }
        static var contentVerticalPadding: CGFloat { 6 }
        static var badgeBorderWidth: CGFloat { 2 }
    }
}
