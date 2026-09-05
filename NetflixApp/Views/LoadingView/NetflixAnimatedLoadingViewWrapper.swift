import SwiftUI

struct NetflixAnimatedLoadingViewWrapper: UIViewRepresentable {
    var isAnimating: Bool
    
    static func dismantleUIView(_ uiView: NetflixAnimatedLoadingView, context: Context) {
        uiView.stopAnimating()
    }
    
    func makeUIView(context: Context) -> NetflixAnimatedLoadingView {
        NetflixAnimatedLoadingView()
    }
    
    func updateUIView(_ uiView: NetflixAnimatedLoadingView, context: Context) {
        if isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
