import SwiftUI

struct AdultContentModifier: ViewModifier {
    @State private var isRevealed = false
    
    let isAdult: Bool
    var scale: CGFloat = Constants.defaultScale

    func body(content: Content) -> some View {
        if isAdult && !isRevealed {
            content
                .blur(radius: Constants.defaultBlurRadius * scale)
                .overlay {
                    Label(Constants.adultLabelText, systemImage: Constants.adultLabelIconSystemName)
                        .font(scale > Constants.defaultScale ? .title.bold() : .title3.bold())
                        .padding(Constants.adultLabelPadding)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .scaleEffect(scale)
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: Constants.revealingAnimationDuration)) {
                        isRevealed = true
                    }
                }
        } else {
            content
        }
    }
}

// MARK: - Constants
private extension AdultContentModifier {
    enum Constants {
        static var defaultScale: CGFloat = 1.0
        static var defaultBlurRadius: CGFloat = 20
        static var adultLabelIconSystemName: String = "hand.raised.fill"
        static var adultLabelText: String = "18+"
        static var adultLabelPadding: CGFloat = 8
        static var revealingAnimationDuration: TimeInterval = 0.4
    }
}
