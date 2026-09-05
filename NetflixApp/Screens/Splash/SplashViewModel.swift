import Foundation

// MARK: - SplashViewModel
final class SplashViewModel {
    var splashFinished: (() -> Void)?

    func startSplashCheckups() {
        Task {
            self.splashFinished?()
        }
    }
}
