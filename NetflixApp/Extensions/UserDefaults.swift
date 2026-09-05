import Foundation

extension UserDefaults {
    private enum Keys {
        static let isOnboardingAlreadySeen = "isOnboardingAlreadySeen"
    }
    
    var hasSeenOnboarding: Bool {
        get {
            bool(forKey: Keys.isOnboardingAlreadySeen)
        }
        set {
            set(newValue, forKey: Keys.isOnboardingAlreadySeen)
        }
    }
}
