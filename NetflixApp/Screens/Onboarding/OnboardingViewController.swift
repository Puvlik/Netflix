import SnapKit
import UIKit

// MARK: - OnboardingViewController
final class OnboardingViewController: UIViewController {
    private let viewModel: OnboardingViewModel
    
    private let backgroundBlurView = OnboardingBackgroundBlurView()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.register(cellClasses: OnboardingCell.self)
        return collection
    }()
    
    private lazy var signInButton: PrimaryButton = {
        let button = PrimaryButton(title: Strings.Onboarding.signInButton)
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = viewModel.onboardingPagesArray.count
        pageControl.pageIndicatorTintColor = Constants.pageControlIndicatorTintColor
        pageControl.currentPageIndicatorTintColor = .netflixMainRed
        return pageControl
    }()
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupUI() {
        view.addSubview(backgroundBlurView)
        backgroundBlurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(Constants.signInButtonBottomOffset)
            make.horizontalEdges.equalToSuperview().inset(Constants.signInButtonHorizontalInset)
            make.height.equalTo(Constants.signInButtonHeight)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(signInButton.snp.top).offset(Constants.pageControlBottomOffset)
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY).offset(Constants.collectionViewTopOffset)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top).offset(Constants.collectionViewBottomOffset)
        }
    }

    @objc private func didTapSignIn() {
        viewModel.signInButtonTapped()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.frame.width > 0 else { return }
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

// MARK: - UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.onboardingPagesArray.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeue(OnboardingCell.self, for: indexPath)
        let pageData = viewModel.onboardingPagesArray[indexPath.item]
        cell.configure(with: pageData)
        cell.onRegister = { [weak self] in
            guard let self else { return }
            self.viewModel.signUpButtonTapped()
        }
        
        return cell
    }
}

// MARK: - Constants
private extension OnboardingViewController {
    enum Constants {
        static var signInButtonBottomOffset: CGFloat = -16
        static var signInButtonHorizontalInset: CGFloat = 16
        static var signInButtonHeight: CGFloat = 45
        static var collectionViewTopOffset: CGFloat = -16
        static var collectionViewBottomOffset: CGFloat = -16
        static var pageControlIndicatorTintColor: UIColor = .systemGray
        static var pageControlBottomOffset: CGFloat = -16
    }
}
