import SwiftUI

// MARK: - NetflixLoaderView
struct NetflixLoaderView: View {
    var size: CGFloat
    
    var body: some View {
        NetflixAnimatedLoadingViewWrapper(isAnimating: true)
            .frame(
                width: size,
                height: size
            )
    }
}
