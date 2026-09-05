import Foundation

struct ProfileModel {
    let name: String
    let email: String
    var favoriteMoviesCount: Int
    let isMember: Bool
}

extension ProfileModel {
    static var unknownUser: ProfileModel {
        ProfileModel(
            name: Strings.Profile.usernameNotFoundText,
            email: Strings.Profile.emailNotFoundText,
            favoriteMoviesCount: .zero,
            isMember: false
        )
    }
}
