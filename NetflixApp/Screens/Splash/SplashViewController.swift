import SnapKit
import UIKit

// MARK: - SplashViewController
final class SplashViewController: UIViewController {
    private let viewModel: SplashViewModel
    
    private let loadingAnimationView = NetflixAnimatedLoadingView()
    private let netflixLogoImageView: UIImageView = {
        let view = UIImageView()
        view.image = Assets.Images.logoNetflix.image
        return view
    }()

    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        makeConstraints()
        loadingAnimationView.startAnimating()
        viewModel.startSplashCheckups()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loadingAnimationView.stopAnimating()
    }
    
    private func makeConstraints() {
        view.addSubview(netflixLogoImageView)
        netflixLogoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(Constants.netflixLogoWidth)
            make.height.equalTo(Constants.netflixLogoHeight)
        }
        
        view.addSubview(loadingAnimationView)
        loadingAnimationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(Constants.loaderCenterYMultiplier)
            make.size.equalTo(Constants.loadingAnimationViewSize)
        }
    }
}

// MARK: - Constants
private extension SplashViewController {
    enum Constants {
        static var netflixLogoHeight: CGFloat = 517
        static var netflixLogoWidth: CGFloat = 284
        static var loaderCenterYMultiplier: CGFloat = 1.75
        static var loaderSizeMultiplier: CGFloat = 1.25
        static var loadingAnimationViewSize: CGFloat = 80
    }
}
