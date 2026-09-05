import SnapKit
import UIKit

// MARK: - OnboardingBackgroundBlurView
final class OnboardingBackgroundBlurView: UIView {
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Assets.Images.onboardingBackground.image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.black.withAlphaComponent(Constants.gradientStartAlpha).cgColor,
            UIColor.black.withAlphaComponent(Constants.gradientEndAlpha).cgColor
        ]
        gradient.locations = Constants.gradientLocations
        return gradient
    }()
    
    private lazy var backgroundBlurView: UIView = {
        let view = UIView()
        view.layer.addSublayer(gradientLayer)
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = backgroundBlurView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(backgroundBlurView)
        backgroundBlurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Constants
private extension OnboardingBackgroundBlurView {
    enum Constants {
        static var gradientStartAlpha: CGFloat = 0.3
        static var gradientEndAlpha: CGFloat = 0.9
        static var gradientLocations: [NSNumber] = [0.0, 1.0]
    }
}
