import SnapKit
import UIKit

// MARK: - SignInViewController
final class SignInViewController: UIViewController {
    private let viewModel: SignInViewModel
    private var isKeyboardVisible = false
    private var isFirstOpen = true
    private var stackViewBottomConstraint: Constraint?
    private var emailGroupHeightConstraint: Constraint?
    private var passwordGroupHeightConstraint: Constraint?
    
    private let netflixLogoImageView: UIImageView = {
        let view = UIImageView()
        view.image = Assets.Images.authFlowNetflixIcon.image
        return view
    }()
    
    private let loadingAnimationView = NetflixAnimatedLoadingView()
    private let loadingOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(Constants.loadingOverlayViewAlpha)
        view.isHidden = true
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.stackViewInnerSpacing
        stack.alignment = .center
        return stack
    }()
    
    private let emailTextField: PrimaryAuthTextField = {
        PrimaryAuthTextField(fieldType: .email, placeholderText: Strings.Auth.emailFieldPlaceholder)
    }()
    private let emailErrorLabel = ErrorLabelView()
    private lazy var emailGroupStackView = createGroup(textField: emailTextField, label: emailErrorLabel)
    
    private let passwordTextField: PrimaryAuthTextField = {
        PrimaryAuthTextField(
            fieldType: .password(register: false),
            placeholderText: Strings.Auth.passwordFieldPlaceholder
        )
    }()
    private let passwordErrorLabel = ErrorLabelView()
    private lazy var passwordGroupStackView = createGroup(textField: passwordTextField, label: passwordErrorLabel)

    private lazy var loginButton: PrimaryButton = {
        let button = PrimaryButton(
            title: Strings.Auth.loginButtonTitle,
            textColor: Assets.Colors.netflixMainRed.color,
            backgroundColor: .clear,
            fontSize: .bold
        )
        button.layer.borderWidth = Constants.loginButtonBorderWidth
        button.layer.borderColor = Assets.Colors.netflixMainRed.color.cgColor
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerButton: PrimaryButton = {
        let button = PrimaryButton(
            title: Strings.Auth.registerButtonTitle,
            textColor: Assets.Colors.authPlaceholderTextColor.color,
            backgroundColor: .clear,
            fontSize: .bold
        )
        button.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        return button
    }()

    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        bindViewModel()
        addEditingGestures()
        addKeyboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addSubview(netflixLogoImageView)
        netflixLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.netflixLogoTopOffset)
            make.width.equalTo(Constants.netflixLogoWidth)
            make.height.equalTo(Constants.netflixLogoHeight)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Constants.stackViewHorizontalInset)
            stackViewBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide)
                .offset(Constants.stackViewBottomOffset)
                .constraint
        }
        
        addGroupToStack(emailGroupStackView, heightConstraint: &emailGroupHeightConstraint)
        addGroupToStack(passwordGroupStackView, heightConstraint: &passwordGroupHeightConstraint)
        
        stackView.addArrangedSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.innerViewDefaultHorizontalInset)
            make.height.equalTo(Constants.innerViewDefaultHeight)
        }
        
        stackView.addArrangedSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.registerButtonHeight)
            make.width.equalTo(Constants.registerButtonWidth)
        }

        view.addSubview(loadingOverlay)
        loadingOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        loadingOverlay.addSubview(loadingAnimationView)
        loadingAnimationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constants.loadingAnimationViewSize)
        }
    }
    
    private func createGroup(textField: PrimaryAuthTextField, label: ErrorLabelView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [textField, label])
        stack.axis = .vertical
        stack.spacing = Constants.groupStackViewInnerSpacing
        return stack
    }
    
    private func addGroupToStack(_ group: UIStackView, heightConstraint: inout Constraint?) {
        stackView.addArrangedSubview(group)
        group.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.innerViewDefaultHorizontalInset)
            heightConstraint = make.height.equalTo(Constants.innerViewDefaultHeight).constraint
        }
    }
    
    private func bindViewModel() {
        viewModel.onEmailErrorChanged = { [weak self] errorText in
            guard let self else { return }
            updateErrorState(
                errorText: errorText,
                textField: self.emailTextField,
                errorLabel: self.emailErrorLabel,
                constraint: self.emailGroupHeightConstraint
            )
        }
        
        viewModel.onPasswordErrorChanged = { [weak self] errorText in
            guard let self else { return }
            updateErrorState(
                errorText: errorText,
                textField: self.passwordTextField,
                errorLabel: self.passwordErrorLabel,
                constraint: self.passwordGroupHeightConstraint
            )
        }
        
        viewModel.onLoginFailed = { [weak self] error in
            guard let self else { return }
            showAlertView(title: Strings.Firebase.loginFailedAlertErrorTitle, message: error)
        }
        
        viewModel.isLoading = { [weak self] isCurrentlyLoading in
            guard let self else { return }
            if isCurrentlyLoading {
                self.loadingOverlay.isHidden = false
                self.loadingAnimationView.startAnimating()
            } else {
                self.loadingOverlay.isHidden = true
                self.loadingAnimationView.stopAnimating()
            }
        }
    }
    
    private func updateErrorState(
        errorText: String?,
        textField: PrimaryAuthTextField,
        errorLabel: ErrorLabelView,
        constraint: Constraint?
    ) {
        textField.hasError = errorText != nil
        errorLabel.text = errorText
        errorLabel.isHidden = errorText == nil
        
        let offset = errorText == nil ? Constants.innerViewDefaultHeight : Constants.innerViewHeightWithError
        constraint?.update(offset: offset)
        
        UIView.animate(withDuration: Constants.defaultAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func addEditingGestures() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func hideTextFieldError(
        for textField: PrimaryAuthTextField,
        hide label: ErrorLabelView,
        update constraint: Constraint?
    ) {
        textField.hasError = false
        label.text = nil
        label.isHidden = true
        constraint?.update(offset: Constants.innerViewDefaultHeight)
        UIView.animate(withDuration: Constants.defaultAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curveInt = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
              let curve = UIView.AnimationCurve(rawValue: curveInt),
              !isKeyboardVisible else { return }

        let safeAreaBottomY = view.safeAreaLayoutGuide.layoutFrame.maxY
        let keyboardTopY = view.convert(keyboardFrame.cgRectValue, from: nil).minY
        let actualOffset = safeAreaBottomY - keyboardTopY + Constants.stackViewWithKeyboardExtraOffset
        stackViewBottomConstraint?.update(offset: -actualOffset)
        if !isFirstOpen {
            isKeyboardVisible = true
        }
        
        isFirstOpen = false
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) {
            self.view.layoutIfNeeded()
        }

        animator.startAnimation()
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curveInt = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
              let curve = UIView.AnimationCurve(rawValue: curveInt) else {
            return
        }
        
        stackViewBottomConstraint?.update(offset: Constants.stackViewBottomOffset)
        isKeyboardVisible = false
        isFirstOpen = true
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) {
            self.view.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
    
    @objc private func didTapLogin() {
        view.endEditing(true)
        viewModel.loginButtonTapped(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @objc private func didTapRegister() {
        view.endEditing(true)
        viewModel.registerButtonTapped()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Constants
private extension SignInViewController {
    enum Constants {
        static var stackViewInnerSpacing: CGFloat = 14
        static var stackViewHorizontalInset: CGFloat = 16
        static var stackViewBottomOffset: CGFloat = -16
        static var stackViewWithKeyboardExtraOffset: CGFloat = 12
        static var groupStackViewInnerSpacing: CGFloat = 2
        static var loginButtonBorderWidth: CGFloat = 2
        static var netflixLogoWidth: CGFloat = 120
        static var netflixLogoHeight: CGFloat = 32
        static var netflixLogoTopOffset: CGFloat = 16
        static var innerViewDefaultHorizontalInset: CGFloat = 8
        static var innerViewDefaultHeight: CGFloat = 64
        static var innerViewHeightWithError: CGFloat = 84
        static var registerButtonHeight: CGFloat = 32
        static var registerButtonWidth: CGFloat = 85
        static var loadingAnimationViewSize: CGFloat = 200
        static var loadingOverlayViewAlpha: CGFloat = 0.4
        static var defaultAnimationDuration: TimeInterval = 0.25
    }
}

// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        switch textField {
        case emailTextField where emailTextField.hasError:
            hideTextFieldError(
                for: emailTextField,
                hide: emailErrorLabel,
                update: emailGroupHeightConstraint
            )
        case passwordTextField where passwordTextField.hasError:
            hideTextFieldError(
                for: passwordTextField,
                hide: passwordErrorLabel,
                update: passwordGroupHeightConstraint
            )
        default:
            break
        }
        
        return true
    }
}
