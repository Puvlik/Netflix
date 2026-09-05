import Lottie
import SnapKit
import UIKit

final class NetflixAnimatedLoadingView: UIView {
    private let animationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: Files.spinnerAnimationJson.name)
        animationView.loopMode = .loop
        animationView.animationSpeed = Constants.animationSpeed
        animationView.contentMode = .scaleAspectFit
        return animationView
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        isHidden = true
        backgroundColor = .clear
        addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func startAnimating() {
        isHidden = false
        animationView.play()
    }
    
    func stopAnimating() {
        isHidden = true
        animationView.stop()
    }
}

// MARK: - Constants
private extension NetflixAnimatedLoadingView {
    enum Constants {
        static var animationSpeed: CGFloat = 2.25
    }
}
