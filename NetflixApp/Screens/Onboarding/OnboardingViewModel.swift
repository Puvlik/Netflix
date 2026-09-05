import Foundation

// MARK: - OnboardingViewModel
final class OnboardingViewModel {
    var onGoToLogin: (() -> Void)?
    var onGoToRegister: (() -> Void)?
        
    let onboardingPagesArray: [OnboardingModel] = [
        OnboardingModel(
            title: Strings.Onboarding.firstTitle,
            body: Strings.Onboarding.firstBody,
            showSignUpButton: false
        ),
        OnboardingModel(
            title: Strings.Onboarding.secondTitle,
            body: Strings.Onboarding.secondBody,
            showSignUpButton: true
        )
    ]
    
    func signInButtonTapped() {
        onGoToLogin?()
    }
    
    func signUpButtonTapped() {
        onGoToRegister?()
    }
}
