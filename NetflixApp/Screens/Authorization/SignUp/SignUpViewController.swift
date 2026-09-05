import SnapKit
import UIKit

// MARK: - SignUpViewController
final class SignUpViewController: UIViewController {
    private let viewModel: SignUpViewModel
    private var usernameGroupHeightConstraint: Constraint?
    private var emailGroupHeightConstraint: Constraint?
    private var passwordGroupHeightConstraint: Constraint?
    private var confirmPasswordGroupHeightConstraint: Constraint?
    private var activeTextField: UITextField?
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: Constants.backButtonConfigPointSize, weight: .bold)
        button.setImage(UIImage(systemName: Constants.backButtonSystemName, withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return button
    }()
    
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
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = false
        return scroll
    }()
    
    private let emptySpacerView = UIView()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.stackViewInnerSpacing
        stack.alignment = .center
        return stack
    }()
    
    private let usernameTextField: PrimaryAuthTextField = {
        PrimaryAuthTextField(fieldType: .username, placeholderText: Strings.Auth.usernameFieldPlaceholder)
    }()
    private let usernameErrorLabel = ErrorLabelView()
    private lazy var usernameGroupStackView = createGroup(textField: usernameTextField, label: usernameErrorLabel)

    private let emailTextField: PrimaryAuthTextField = {
        PrimaryAuthTextField(fieldType: .email, placeholderText: Strings.Auth.emailFieldPlaceholder)
    }()
    private let emailErrorLabel = ErrorLabelView()
    private lazy var emailGroupStackView = createGroup(textField: emailTextField, label: emailErrorLabel)

    private let passwordTextField: PrimaryAuthTextField = {
        PrimaryAuthTextField(
            fieldType: .password(register: true),
            placeholderText: Strings.Auth.passwordFieldPlaceholder
        )
    }()
    private let passwordErrorLabel = ErrorLabelView()
    private lazy var passwordGroupStackView = createGroup(textField: passwordTextField, label: passwordErrorLabel)
    
    private let confirmPasswordTextField: PrimaryAuthTextField = {
        PrimaryAuthTextField(
            fieldType: .confirmPassword,
            placeholderText: Strings.Auth.confirmPasswordFieldPlaceholder
        )
    }()
    private let confirmPasswordErrorLabel = ErrorLabelView()
    private lazy var confirmPasswordGroupStackView = createGroup(
        textField: confirmPasswordTextField,
        label: confirmPasswordErrorLabel
    )
    
    private lazy var registerButton: PrimaryButton = {
        let button = PrimaryButton(
            title: Strings.Auth.registerButtonTitle,
            textColor: Assets.Colors.netflixMainRed.color,
            backgroundColor: .clear,
            fontSize: .bold
        )
        button.layer.borderWidth = Constants.registerButtonBorderWidth
        button.layer.borderColor = Assets.Colors.netflixMainRed.color.cgColor
        button.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: SignUpViewModel) {
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
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        view.addSubview(netflixLogoImageView)
        netflixLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.netflixLogoTopOffset)
            make.width.equalTo(Constants.netflixLogoWidth)
            make.height.equalTo(Constants.netflixLogoHeight)
        }
        
        setupRegisterStackConstraints()
        
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
    
    private func setupRegisterStackConstraints() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.backButtonTopOffset)
            make.leading.equalToSuperview().offset(Constants.backButtonLeadingOffset)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(netflixLogoImageView.snp.bottom).offset(Constants.scrollViewTopOffset)
            make.horizontalEdges.equalToSuperview().inset(Constants.scrollViewHorizontalInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(Constants.scrollViewBottomOffset)
        }

        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
        
        stackView.addArrangedSubview(emptySpacerView)
        addGroupToStack(usernameGroupStackView, heightConstraint: &usernameGroupHeightConstraint)
        addGroupToStack(emailGroupStackView, heightConstraint: &emailGroupHeightConstraint)
        addGroupToStack(passwordGroupStackView, heightConstraint: &passwordGroupHeightConstraint)
        addGroupToStack(confirmPasswordGroupStackView, heightConstraint: &confirmPasswordGroupHeightConstraint)
        
        stackView.addArrangedSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.innerViewDefaultHorizontalInset)
            make.height.equalTo(Constants.innerViewDefaultHeight)
        }
    }
    
    private func bindRegisterErrorClosures() {
        viewModel.onUsernameErrorChanged = { [weak self] errorText in
            guard let self else { return }
            updateErrorState(
                errorText: errorText,
                textField: self.usernameTextField,
                errorLabel: self.usernameErrorLabel,
                constraint: self.usernameGroupHeightConstraint
            )
        }
        
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
        
        viewModel.onConfirmPasswordErrorChanged = { [weak self] errorText in
            guard let self else { return }
            updateErrorState(
                errorText: errorText,
                textField: self.confirmPasswordTextField,
                errorLabel: self.confirmPasswordErrorLabel,
                constraint: self.confirmPasswordGroupHeightConstraint
            )
        }
    }
    
    private func bindViewModel() {
        bindRegisterErrorClosures()
        
        viewModel.onRegisterFailed = { [weak self] error in
            guard let self else { return }
            showAlertView(title: Strings.Firebase.registerFailedAlertErrorTitle, message: error)
        }
        
        viewModel.onRegisterUsernameNotSaved = { [weak self] error in
            guard let self else { return }
            showAlertView(title: Strings.Firebase.usernameNotSavedAlertErrorTitle, message: error) {
                self.viewModel.closeUsernameErrorAlert()
            }
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
              let curve = UIView.AnimationCurve(rawValue: curveInt) else { return }

        let safeAreaBottomY = view.safeAreaLayoutGuide.layoutFrame.maxY
        let keyboardTopY = view.convert(keyboardFrame.cgRectValue, from: nil).minY
        let actualOffset = safeAreaBottomY - keyboardTopY
        scrollView.contentInset.bottom = actualOffset
        
        var rectToScrollTo: CGRect?
        if let activeField = activeTextField {
            rectToScrollTo = activeField.convert(activeField.bounds, to: scrollView)
                .insetBy(dx: .zero, dy: Constants.scrollRectToVisibleInset)
        }
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) {
            if let rect = rectToScrollTo {
                self.scrollView.scrollRectToVisible(rect, animated: false)
            }
            self.view.layoutIfNeeded()
        }

        animator.startAnimation()
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
    }
    
    @objc private func didTapRegister() {
        view.endEditing(true)
        viewModel.registerButtonTapped(
            username: usernameTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text,
            confirmPassword: confirmPasswordTextField.text
        )
    }
    
    @objc private func didTapBack() {
        viewModel.backButtonTapped()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Constants
private extension SignUpViewController {
    enum Constants {
        static var backButtonSystemName: String = "chevron.left"
        static var backButtonTopOffset: CGFloat = 18
        static var backButtonLeadingOffset: CGFloat = 24
        static var backButtonConfigPointSize: CGFloat = 20
        static var stackViewInnerSpacing: CGFloat = 14
        static var scrollRectToVisibleInset: CGFloat = -16
        static var scrollViewHorizontalInset: CGFloat = 16
        static var scrollViewBottomOffset: CGFloat = -16
        static var scrollViewTopOffset: CGFloat = 16
        static var groupStackViewInnerSpacing: CGFloat = 2
        static var registerButtonBorderWidth: CGFloat = 2
        static var netflixLogoWidth: CGFloat = 120
        static var netflixLogoHeight: CGFloat = 32
        static var netflixLogoTopOffset: CGFloat = 16
        static var innerViewDefaultHorizontalInset: CGFloat = 8
        static var innerViewDefaultHeight: CGFloat = 64
        static var innerViewHeightWithError: CGFloat = 84
        static var loadingAnimationViewSize: CGFloat = 200
        static var loadingOverlayViewAlpha: CGFloat = 0.4
        static var defaultAnimationDuration: TimeInterval = 0.25
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        default:
            confirmPasswordTextField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        switch textField {
        case usernameTextField where usernameTextField.hasError:
            hideTextFieldError(
                for: usernameTextField,
                hide: usernameErrorLabel,
                update: usernameGroupHeightConstraint
            )
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
        case confirmPasswordTextField where confirmPasswordTextField.hasError:
            hideTextFieldError(
                for: confirmPasswordTextField,
                hide: confirmPasswordErrorLabel,
                update: confirmPasswordGroupHeightConstraint
            )
        default:
            break
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if activeTextField == textField {
            activeTextField = nil
        }
    }
}
