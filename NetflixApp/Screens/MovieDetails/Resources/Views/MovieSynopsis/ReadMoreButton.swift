import SwiftUI

// MARK: - ReadMoreButton
struct ReadMoreButton: View {
    @Binding var showReadMore: Bool
    @Binding var isExpanded: Bool
    
    var body: some View {
        Button {
            showReadMore = false
            
            withAnimation {
                isExpanded = true
            }
        } label: {
            Text(Strings.MovieDetails.readMoreButtonText)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .background(.black)
                .padding(.leading, Constants.readMoreButtonLeadingPadding)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .black.opacity(.zero),
                            .black,
                            .black,
                            .black
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
        .opacity(showReadMore ? Constants.readMoreButtonOpacity : .zero)
        .allowsHitTesting(showReadMore)
    }
}

// MARK: - Constants
private extension ReadMoreButton {
    enum Constants {
        static var readMoreButtonOpacity: Double = 1
        static var readMoreButtonLeadingPadding: CGFloat = 40
    }
}
