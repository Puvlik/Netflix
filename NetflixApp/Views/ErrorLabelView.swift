import UIKit

final class ErrorLabelView: UILabel {
    init() {
        super.init(frame: .zero)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        textColor = Assets.Colors.netflixMainRed.color
        font = .systemFont(ofSize: Constants.errorFontSize, weight: .bold)
        numberOfLines = .zero
        isHidden = true
    }
}

// MARK: - Constants
private extension ErrorLabelView {
    enum Constants {
        static var errorLines: Int = 0
        static var errorFontSize: CGFloat = 14
    }
}
