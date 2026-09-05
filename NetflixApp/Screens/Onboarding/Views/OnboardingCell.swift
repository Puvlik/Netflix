import SnapKit
import UIKit

// MARK: - OnboardingCell
final class OnboardingCell: UICollectionViewCell {
    var onRegister: (() -> Void)?
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.stackViewInnerSpacing
        stack.alignment = .center
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.titleLabelFontSize, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = Constants.titleLabelLinesNumber
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.bodyLabelFontSize, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var signUpButton: PrimaryButton = {
        let button = PrimaryButton(title: Strings.Onboarding.signUpButton)
        button.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)
        stackView.addArrangedSubview(signUpButton)
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Constants.stackHorizontalInset)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.bodyLabelHorizontalInset)
        }
        
        stackView.setCustomSpacing(Constants.stackViewCustomSpacingForSignUp, after: bodyLabel)
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.signUpButtonHeight)
            make.width.equalTo(Constants.signUpButtonWidth)
        }
    }
    
    func configure(with page: OnboardingModel) {
        titleLabel.text = page.title
        bodyLabel.text = page.body
        signUpButton.isHidden = !page.showSignUpButton
    }
    
    @objc private func didTapRegister() {
        onRegister?()
    }
}

// MARK: - Constants
private extension OnboardingCell {
    enum Constants {
        static var stackViewInnerSpacing: CGFloat = 16
        static var stackViewCustomSpacingForSignUp: CGFloat = 32
        static var stackHorizontalInset: CGFloat = 16
        static var titleLabelFontSize: CGFloat = 30
        static var titleLabelLinesNumber: Int = 1
        static var bodyLabelFontSize: CGFloat = 20
        static var bodyLabelHorizontalInset: CGFloat = 24
        static var signUpButtonHeight: CGFloat = 35
        static var signUpButtonWidth: CGFloat = 180
    }
}
