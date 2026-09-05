import SwiftUI

// MARK: - ProfileInfoView
struct ProfileInfoView: View {
    var imageName: String
    var name: String
    var email: String
    var isMember: Bool
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .foregroundColor(.white)
                .frame(width: Constants.profileImageSize, height: Constants.profileImageSize)
            
            HStack(spacing: Constants.profileCredentialsStackSpacing) {
                Text(name)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                if isMember {
                    memberBadgeView
                }
            }
            
            Text(email)
                .font(.headline)
                .foregroundColor(.gray)
        }
    }
    
    private var memberBadgeView: some View {
        Text(Strings.Profile.memberViewText.uppercased())
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, Constants.memberBadgeTextHorizontalPadding)
            .padding(.vertical, Constants.memberBadgeTextVerticalPadding)
            .foregroundColor(Constants.memberBadgeTextColor)
            .background(Constants.memberBadgeBackgroundColor)
            .cornerRadius(Constants.memberBadgeCornerRadius)
    }
}

// MARK: - Constants
private extension ProfileInfoView {
    enum Constants {
        static var profileImageSize: CGFloat = 125
        static var profileCredentialsStackSpacing: CGFloat = 16
        static var memberBadgeCornerRadius: CGFloat = 4
        static var memberBadgeTextHorizontalPadding: CGFloat = 8
        static var memberBadgeTextVerticalPadding: CGFloat = 4
        static let memberBadgeTextColor = Color(red: 0.0, green: 0.8, blue: 0.4)
        static let memberBadgeBackgroundColor = Color(red: 0.0, green: 0.3, blue: 0.2)
    }
}
