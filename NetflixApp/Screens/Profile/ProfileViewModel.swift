import Foundation
import os

// MARK: - ProfileViewModel
@MainActor
@Observable
final class ProfileViewModel {
    var userProfile: ProfileModel
    var logOutErrorMessage: String?
    var showLogoutErrorAlert = false
    var showClearCacheErrorAlert = false
    var showLogoutConfirmationAlert = false
    var showClearCacheConfirmationAlert = false
    var isClearingCache = false
    var cacheClearedSuccessfully = false
    private var isLoggingOutInProgress = false
    
    var onDismissTapped: (() -> Void)?
    var onLogoutSuccess: (() -> Void)?
    var onCacheCleared: (() -> Void)?
    
    private let authService: AuthServiceProtocol
    private let coreDataService: ProfileDependencies
    private let imageCache: ImageCachingProtocol
    
    init(
        authService: AuthServiceProtocol,
        coreDataService: ProfileDependencies,
        imageCache: ImageCachingProtocol
    ) {
        self.authService = authService
        self.coreDataService = coreDataService
        self.imageCache = imageCache
        
        guard let authUser = authService.getCurrentUser() else {
            self.userProfile = .unknownUser
            return
        }

        self.userProfile = ProfileModel(
            name: authUser.name ?? Strings.Profile.usernameNotFoundText,
            email: authUser.email ?? Strings.Profile.emailNotFoundText,
            favoriteMoviesCount: .zero,
            isMember: true
        )
    }
    
    func closeProfilePage() {
        guard !isLoggingOutInProgress else { return }
        onDismissTapped?()
    }
    
    func clearCacheButtonTapped() {
        showClearCacheConfirmationAlert = true
    }
    
    func loadStatistics() {
        Task {
            do {
                let count = try await coreDataService.getFavoriteMoviesCount()
                self.userProfile.favoriteMoviesCount = count
            } catch {
                AppLogger.coreData.error("Failed to load favorites count: \(error.localizedDescription)")
            }
        }
    }
    
    func performCacheClear() {
        isClearingCache = true
        
        Task {
            do {
                try await coreDataService.clearLocalCache()
                let favoriteImagePaths = try await coreDataService.getFavoriteMovieImagePaths()
                try await imageCache.clearCache(except: favoriteImagePaths)
                URLCache.shared.removeAllCachedResponses()
                onCacheCleared?()
                try? await Task.sleep(for: .seconds(Constants.clearingCoreDataLoaderDuration))
                isClearingCache = false
                cacheClearedSuccessfully = true
                try? await Task.sleep(for: .seconds(Constants.clearedSuccessfullyButtonStateDuration))
                cacheClearedSuccessfully = false
            } catch let error {
                isClearingCache = false
                showClearCacheErrorAlert = true
                AppLogger.coreData.error(
                    "Failed to clear local Core Data. Error: \(error.localizedDescription)"
                )
            }
        }
    }

    func logoutButtonTapped() {
        guard !isLoggingOutInProgress else { return }
        showLogoutConfirmationAlert = true
    }
    
    func performLogout() {
        guard !isLoggingOutInProgress else { return }
        
        isLoggingOutInProgress = true
        
        defer {
            isLoggingOutInProgress = false
        }

        if let errorText = authService.logoutUser() {
            logOutErrorMessage = errorText
            showLogoutErrorAlert = true
        } else {
            onLogoutSuccess?()
        }
    }
}

// MARK: - Constants
private extension ProfileViewModel {
    enum Constants {
        static var clearingCoreDataLoaderDuration: Int = 1
        static var clearedSuccessfullyButtonStateDuration: Int = 2
    }
}
