import UIKit

extension UIViewController {
    func addCustomBackButton(target: Any, action: Selector) {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: target,
            action: action
        )
        navigationItem.leftBarButtonItem = backButton
    }

    func showAlertView(title: String, message: String, action: (() -> Void)? = nil) {
        let alertMessagePopUpBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: Strings.Common.okButtonTitle, style: .default) { _ in action?() }
        alertMessagePopUpBox.addAction(okButton)
        self.present(alertMessagePopUpBox, animated: true)
    }
}
