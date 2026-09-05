import SwiftUI

// MARK: - MovieImageLoadingView
struct MovieImageLoadingView: View {
    var loaderSize: CGFloat
    
    var body: some View {
        ZStack {
            MoviePlaceholderView()
            NetflixLoaderView(size: loaderSize)
        }
    }
}
