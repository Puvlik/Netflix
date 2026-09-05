import SwiftUI

// MARK: - MovieSynopsisSectionExpandableView
struct MovieSynopsisSectionExpandableView: View {
    let movieDescription: String
    
    @State private var isExpanded: Bool = false
    @State private var showReadMore: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.contentStackSpacing) {
            Text(Strings.MovieDetails.movieDescriptionSectionTitle)
                .font(.title3)
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: Constants.buttonsAndDescriptionSpacing) {
                MovieSynopsisView(
                    movieDescription: movieDescription,
                    showReadMore: $showReadMore,
                    isExpanded: $isExpanded
                )
                
                if isExpanded {
                    HideMoreButton(showReadMore: $showReadMore, isExpanded: $isExpanded)
                        .transition(.opacity)
                }
            }
        }
        .bold()
        .clipped()
    }
}

// MARK: - Constants
private extension MovieSynopsisSectionExpandableView {
    enum Constants {
        static var contentStackSpacing: CGFloat = 8
        static var buttonsAndDescriptionSpacing: CGFloat = 4
    }
}
