enum MovieTabs: String, CaseIterable {
    case home = "Home"
    case comingSoon = "Coming Soon"
    case favorites = "Favorites"
    
    init?(index: Int) {
        guard let tab = MovieTabs.allCases.first(where: { $0.index == index }) else { return nil }
        self = tab
    }
    
    var index: Int {
        switch self {
        case .home:
            return 0
        case .comingSoon:
            return 1
        case .favorites:
            return 2
        }
    }
    
    var systemImageName: String {
        switch self {
        case .home: 
            return "house"
        case .comingSoon: 
            return "calendar"
        case .favorites: 
            return "heart"
        }
    }
}
