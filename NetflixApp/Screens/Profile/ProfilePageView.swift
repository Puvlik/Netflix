import SwiftUI

// MARK: - ProfilePageView
struct ProfilePageView: View {
    @Bindable var viewModel: ProfileViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            
            VStack {
                ProfileHeaderView {
                    viewModel.closeProfilePage()
                }
                
                Divider()
                    .frame(height: Constants.topDividerHeight)
                    .background(.gray)
                    .padding(.horizontal)
                
                profileInfoDetailsView
                    .padding(.top)
                
                Spacer()
                
                ClearCacheButton(
                    isClearingCache: viewModel.isClearingCache,
                    isCacheClearedSuccessfully: viewModel.cacheClearedSuccessfully
                ) {
                    viewModel.clearCacheButtonTapped()
                }
                .padding(.bottom)
                
                logoutButton
                    .padding(.bottom, Constants.logoutButtonBottomPadding)
            }
        }
        .modifier(NetworkBannerModifier())
        .padding(.top, Constants.contentTopPadding)
        .task {
            viewModel.loadStatistics()
        }
        .alert(
            Strings.Profile.failedToLogoutAlertTitle,
            isPresented: $viewModel.showLogoutErrorAlert
        ) {
            Button(Strings.Common.okButtonTitle, role: .cancel) {
                viewModel.logOutErrorMessage = nil
            }
        } message: {
            Text(viewModel.logOutErrorMessage ?? Strings.Firebase.unknownErrorText)
        }
        .alert(
            Strings.Profile.logoutConfirmationAlertTitle,
            isPresented: $viewModel.showLogoutConfirmationAlert
        ) {
            Button(Strings.Profile.logoutButtonTitle, role: .destructive) {
                viewModel.performLogout()
            }
            
            Button(Strings.Common.cancelButtonTitle, role: .cancel) { }
        } message: {
            Text(Strings.Profile.logoutConfirmationAlertDescription)
        }
        .alert(
            Strings.Profile.failedToClearCacheAlertTitle,
            isPresented: $viewModel.showClearCacheErrorAlert
        ) {
            Button(Strings.Common.okButtonTitle, role: .cancel) {}
        } message: {
            Text(Strings.Profile.failedToClearCacheAlertDescription)
        }
        .alert(
            Strings.Profile.clearCacheConfirmationAlertTitle,
            isPresented: $viewModel.showClearCacheConfirmationAlert
        ) {
            Button(Strings.Common.clearButtonTitle, role: .destructive) {
                viewModel.performCacheClear()
            }
            
            Button(Strings.Common.cancelButtonTitle, role: .cancel) { }
        } message: {
            Text(Strings.Profile.clearCacheConfirmationAlertDescription)
        }
    }
    
    // MARK: - Private views
    
    private var profileInfoDetailsView: some View {
        VStack(spacing: Constants.profileInfoStackSpacing) {
            ProfileInfoView(
                imageName: Assets.Images.profileImageIcon.name,
                name: viewModel.userProfile.name,
                email: viewModel.userProfile.email,
                isMember: viewModel.userProfile.isMember
            )
            
            ProfileStatisticsView(favoritesCount: viewModel.userProfile.favoriteMoviesCount)
        }
    }
    
    private var logoutButton: some View {
        Button {
            viewModel.logoutButtonTapped()
        } label: {
            Text(Strings.Profile.logoutButtonTitle)
                .font(.system(size: Constants.logoutButtonFontSize, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: Constants.logoutButtonHeight)
                .background(Assets.Colors.netflixMainRed.swiftUIColor)
                .cornerRadius(Constants.logoutButtonCornerRadius)
        }
        .padding(.horizontal)
    }
}

// MARK: - Constants
private extension ProfilePageView {
    enum Constants {
        static var topDividerHeight: CGFloat = 1
        static var profileInfoStackSpacing: CGFloat = 36
        static var contentTopPadding: CGFloat = 8
        static var logoutButtonFontSize: CGFloat = 25
        static var logoutButtonHeight: CGFloat = 50
        static var logoutButtonCornerRadius: CGFloat = 12
        static var logoutButtonBottomPadding: CGFloat = 40
    }
}
