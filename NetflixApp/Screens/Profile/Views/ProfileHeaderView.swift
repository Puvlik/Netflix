import SwiftUI

// MARK: - ProfileHeaderView
struct ProfileHeaderView: View {
    let backAction: () -> Void
    
    var body: some View {
        Text(Strings.Profile.screenTitle)
            .frame(maxWidth: .infinity, alignment: .center)
            .overlay(alignment: .leading) {
                Button(action: backAction) {
                    Image(systemName: Constants.backButtonIconName)
                }
            }
            .font(.system(size: Constants.headerTitleFontSize, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal)
    }
}

// MARK: - Constants
private extension ProfileHeaderView {
    enum Constants {
        static var backButtonIconName: String = "chevron.backward"
        static var headerTitleFontSize: CGFloat = 25
    }
}
