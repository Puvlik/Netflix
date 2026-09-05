import SwiftUI

struct MovieSynopsisView: View {
    let movieDescription: String
    
    @Binding var showReadMore: Bool
    @Binding var isExpanded: Bool
    @State private var isTruncated: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Text(movieDescription)
                .font(.subheadline)
                .lineSpacing(Constants.movieDescriptionLineSpacing)
                .lineLimit(isExpanded ? nil : Constants.movieDescriptionLinesCount)
                .hidden()
                .background(truncationMeasurementLayer)
                .overlay(alignment: .topLeading) {
                    Text(movieDescription)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineSpacing(Constants.movieDescriptionLineSpacing)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .clipped()
                .animation(.easeInOut, value: isExpanded)

            if isTruncated {
                ReadMoreButton(showReadMore: $showReadMore, isExpanded: $isExpanded)
            }
        }
    }
    
    private var truncationMeasurementLayer: some View {
        GeometryReader { limitedGeo in
            Text(movieDescription)
                .font(.subheadline)
                .lineSpacing(Constants.movieDescriptionLineSpacing)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .hidden()
                .background(
                    GeometryReader { fullGeo in
                        Color.clear
                            .onChange(of: fullGeo.size, initial: true) { _, newSize in
                                isTruncated = newSize.height > limitedGeo.size.height
                            }
                    }
                )
        }
    }
}

// MARK: - Constants
private extension MovieSynopsisView {
    enum Constants {
        static var movieDescriptionLinesCount: Int = 3
        static var movieDescriptionLineSpacing: CGFloat = 2
    }
}
