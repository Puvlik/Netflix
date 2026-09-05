import SwiftUI

// MARK: - FeaturedMovieTopBlurView
struct FeaturedMovieTopBlurView: View {
    var onProfileTap: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .center) {
            Image(Assets.Images.logoNetflix.name)
                .resizable()
                .frame(width: Constants.netflixLogoWidth, height: Constants.netflixLogoHeight)

            Spacer()

            Button {
                onProfileTap?()
            } label: {
                Image(Assets.Images.profileImageIcon.name)
                    .resizable()
                    .frame(width: Constants.profileIconSideValue, height: Constants.profileIconSideValue)
                    .cornerRadius(Constants.profileIconCornerRadius)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, Constants.bottomPadding)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(
                        color: .black.opacity(Constants.gradientStartOpacity),
                        location: Constants.gradientStartLocation
                    ),
                    Gradient.Stop(color: .clear, location: Constants.gradientEndLocation)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .allowsHitTesting(false)
        )
    }
}

// MARK: - Constants
private extension FeaturedMovieTopBlurView {
    enum Constants {
        static var netflixLogoWidth: CGFloat = 45
        static var netflixLogoHeight: CGFloat = 70
        static var profileIconSideValue: CGFloat = 28
        static var profileIconCornerRadius: CGFloat = 6
        static var bottomPadding: CGFloat = 40
        static var gradientStartOpacity: Double = 0.6
        static var gradientStartLocation: CGFloat = 0.8
        static var gradientEndLocation: CGFloat = 1.0
    }
}
