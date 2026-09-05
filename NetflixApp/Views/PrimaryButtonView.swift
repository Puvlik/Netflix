import SnapKit
import UIKit

final class PrimaryButton: UIButton {    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: Constants.highlightedTimeInterval) {
                self.alpha = self.isHighlighted ? Constants.buttonHighlightedAlpha : Constants.buttonDefaultAlpha
            }
        }
    }
    
    init(
        title: String,
        textColor: UIColor = .white,
        backgroundColor: UIColor = Assets.Colors.netflixMainRed.color,
        fontSize: UIFont.Weight = .medium
    ) {
        super.init(frame: .zero)
        setupStyle(title: title, textColor: textColor, backgroundColor: backgroundColor, fontWeight: fontSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle(
        title: String,
        textColor: UIColor,
        backgroundColor: UIColor,
        fontWeight: UIFont.Weight
    ) {
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        self.backgroundColor = backgroundColor
        titleLabel?.font = .systemFont(ofSize: Constants.buttonTitleFontSize, weight: fontWeight)
        layer.cornerRadius = Constants.buttonCornerRadius
    }
}

// MARK: - Constants
private extension PrimaryButton {
    enum Constants {
        static var buttonCornerRadius: CGFloat = 8
        static var buttonTitleFontSize: CGFloat = 16
        static var highlightedTimeInterval: TimeInterval = 0.1
        static var buttonHighlightedAlpha: CGFloat = 0.85
        static var buttonDefaultAlpha: CGFloat = 1.0
    }
}
