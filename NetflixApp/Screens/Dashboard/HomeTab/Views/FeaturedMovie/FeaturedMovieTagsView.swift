import SwiftUI

struct FeaturedMovieTagsView: View {
    let movieTags: [String]
    
    var body: some View {
        buildMultilineTagsText()
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .padding(.horizontal)
    }
    
    private func buildMultilineTagsText() -> Text {
        guard !movieTags.isEmpty else {
            return Text(Strings.Common.emptyString)
        }

        var combinedText = Text(movieTags[0])
            .foregroundColor(.white)

        (1..<movieTags.count).forEach { index in
            let spaces = Text(Strings.Common.stringWithSpaceCharacter)
            let dotIcon = Text(Image(systemName: Constants.dotIconSystemName))
                .font(.system(size: Constants.dotIconFontSize))
                .foregroundColor(Assets.Colors.tagsSeparator.swiftUIColor)
                .baselineOffset(Constants.dotIconBaselineOffset)
            let dot = spaces + dotIcon + spaces
            
            let nextTag = Text(movieTags[index])
                .foregroundColor(.white)
            
            combinedText = combinedText + dot + nextTag
        }

        return combinedText
            .font(.subheadline)
            .fontWeight(.semibold)
    }
}

// MARK: - Constants
private extension FeaturedMovieTagsView {
    enum Constants {
        static var dotIconSystemName: String = "circle.fill"
        static var dotIconFontSize: CGFloat = 5
        static var dotIconBaselineOffset: CGFloat = 1.75
    }
}
