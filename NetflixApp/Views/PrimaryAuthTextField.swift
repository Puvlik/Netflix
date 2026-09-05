import UIKit

final class PrimaryAuthTextField: UITextField {
    enum FieldType {
        case username
        case email
        case password(register: Bool)
        case confirmPassword
    }
    
    var hasError: Bool = false {
        didSet {
            layer.borderWidth = hasError ? Constants.errorBorderWidth : .zero
            layer.borderColor = hasError ? Assets.Colors.netflixMainRed.color.cgColor : UIColor.clear.cgColor
        }
    }
    
    private lazy var showPasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(Strings.Auth.showPasswordButtonTitle, for: .normal)
        button.setTitleColor(Assets.Colors.authPlaceholderTextColor.color, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.showPasswordButtonFontSize, weight: .semibold)
        button.addTarget(self, action: #selector(didTapToggle), for: .touchUpInside)
        return button
    }()

    init(fieldType: FieldType, placeholderText: String) {
        super.init(frame: .zero)
        self.placeholder = placeholderText
        setupTextField()
        configure(for: fieldType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        calculatePadding(for: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        calculatePadding(for: bounds)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        calculatePadding(for: bounds)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= Constants.showPasswordButtonRightPadding
        return rect
    }

    private func setupTextField() {
        backgroundColor = Assets.Colors.netflixMainGray.color
        layer.cornerRadius = Constants.textFieldCornerRadius
        textColor = .white
        font = .systemFont(ofSize: Constants.textFieldFontSize, weight: .semibold)
        tintColor = .white

        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? Strings.Common.emptyString,
            attributes: [.foregroundColor: Assets.Colors.authPlaceholderTextColor.color]
        )
    }
    
    private func configure(for type: FieldType) {
        autocorrectionType = .no
        autocapitalizationType = .none
        spellCheckingType = .no
        
        switch type {
        case .username:
            isSecureTextEntry = false
            textContentType = .name
            keyboardType = .default
            autocapitalizationType = .words
            returnKeyType = .next
        case .email:
            isSecureTextEntry = false
            textContentType = .username
            keyboardType = .emailAddress
            returnKeyType = .next
        case .password(let isRegister):
            isSecureTextEntry = true
            textContentType = isRegister ? .newPassword : .password
            keyboardType = .asciiCapable
            returnKeyType = isRegister ? .next : .done
            rightView = showPasswordButton
            rightViewMode = .always
        case .confirmPassword:
            isSecureTextEntry = true
            textContentType = .password
            keyboardType = .asciiCapable
            returnKeyType = .done
            rightView = showPasswordButton
            rightViewMode = .always
        }
    }
    
    private func calculatePadding(for bounds: CGRect) -> CGRect {
        let insets = UIEdgeInsets(
            top: .zero,
            left: Constants.textFieldHorizontalInset,
            bottom: .zero,
            right: Constants.textFieldHorizontalInset
        )
        
        var rect = bounds.inset(by: insets)
        if let view = rightView {
            rect.size.width -= view.bounds.width + Constants.passwordExtraRightTextInset
        }
        
        return rect
    }
    
    @objc private func didTapToggle() {
        isSecureTextEntry.toggle()
        let buttonText = isSecureTextEntry ? Strings.Auth.showPasswordButtonTitle : Strings.Auth.hidePasswordButtonTitle
        showPasswordButton.setTitle(buttonText, for: .normal)
        
        if let currentText = text {
            text = Strings.Common.emptyString
            insertText(currentText)
        }
    }
}

// MARK: - Constants
private extension PrimaryAuthTextField {
    enum Constants {
        static var showPasswordButtonFontSize: CGFloat = 16
        static var showPasswordButtonRightPadding: CGFloat = 16
        static var passwordExtraRightTextInset: CGFloat = 8
        static var textFieldFontSize: CGFloat = 16
        static var textFieldCornerRadius: CGFloat = 8
        static var textFieldHorizontalInset: CGFloat = 16
        static var errorBorderWidth: CGFloat = 2
    }
}
