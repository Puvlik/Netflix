import SwiftUI

struct MoviesSearchBar: View {
    @FocusState private var isFocused: Bool
    @Binding var searchText: String
    
    var body: some View {
        let showPlaceholder = searchText.isEmpty && !isFocused
        
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: Constants.searchBarCornerRadius)
                .fill(Assets.Colors.netflixMainGray.swiftUIColor)
                .frame(height: Constants.searchBarHeight)
            
            HStack {
                Image(systemName: Constants.magnifyingGlassIconSystemName)
                Text(Strings.ComingSoon.searchBarPlaceholder)
                    .fontWeight(.bold)
            }
            .foregroundColor(Assets.Colors.authPlaceholderTextColor.swiftUIColor)
            .allowsHitTesting(false)
            .opacity(showPlaceholder ? Constants.placeholderStartOpacity : .zero)
            
            HStack(alignment: .center) {
                TextField(
                    Strings.Common.emptyString,
                    text: $searchText
                )
                .textFieldStyle(.plain)
                .focused($isFocused)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = Strings.Common.emptyString
                        isFocused = false
                    } label: {
                        Image(systemName: Constants.clearSearchTextButtonIconSystemName)
                    }
                    .transition(.opacity.combined(with: .scale))
                }
            }
            .padding(.horizontal)
            .font(.system(size: Constants.searchBarFontSize, weight: .semibold))
            .foregroundColor(.white)
            .tint(.white)
        }
        .padding(.horizontal, Constants.contentHorizontalPadding)
        .animation(.easeInOut, value: showPlaceholder)
    }
}

// MARK: - Constants
private extension MoviesSearchBar {
    enum Constants {
        static var contentHorizontalPadding: CGFloat = 8
        static var searchBarCornerRadius: CGFloat = 12
        static var searchBarHeight: CGFloat = 40
        static var magnifyingGlassIconSystemName: String = "magnifyingglass"
        static var clearSearchTextButtonIconSystemName: String = "xmark.circle.fill"
        static var placeholderStartOpacity: Double = 1
        static var searchBarFontSize: CGFloat = 16
    }
}
