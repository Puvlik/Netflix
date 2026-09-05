import SwiftUI

// MARK: - ProfileStatisticsView
struct ProfileStatisticsView: View {
    var favoritesCount: Int
    
    var body: some View {
        VStack(spacing: Constants.statisticsViewStackSpacing) {
            VStack(spacing: Constants.statisticsInnerSpacing) {
                Text(String(favoritesCount))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(Strings.Profile.userFavoritesCountTitle.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
            
            Divider()
                .frame(width: Constants.statisticsDividerWidth, height: Constants.statisticsDividerHeight)
                .background(.gray)
        }
    }
}

// MARK: - Constants
private extension ProfileStatisticsView {
    enum Constants {
        static var statisticsViewStackSpacing: CGFloat = 10
        static var statisticsInnerSpacing: CGFloat = 4
        static var statisticsDividerWidth: CGFloat = 115
        static var statisticsDividerHeight: CGFloat = 1
    }
}
