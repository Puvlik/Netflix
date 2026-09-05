import SwiftUI

struct PlayMovieTrailerButtonView: View {
    var body: some View {
        Button {} label: {
            Label {
                Text(Strings.HomeTab.playButtonTitle)
                    .font(.headline)
                    .fontWeight(.bold)
            } icon: {
                Image(systemName: Constants.playButtonIconSystemName)
                    .font(.title2)
            }
            .padding(.vertical, Constants.playButtonStackVerticalPadding)
            .padding(.horizontal)
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(Constants.playButtonCornerRadius)
        }
    }
}

// MARK: - Constants
private extension PlayMovieTrailerButtonView {
    enum Constants {
        static var playButtonIconSystemName: String = "play.fill"
        static var playButtonStackVerticalPadding: CGFloat = 8
        static var playButtonCornerRadius: CGFloat = 8
    }
}
