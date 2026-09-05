import SwiftUI

// MARK: - HideMoreButton
struct HideMoreButton: View {
    @Binding var showReadMore: Bool
    @Binding var isExpanded: Bool
    
    var body: some View {
        Button {
            withAnimation {
                isExpanded = false
            }
            
            Task {
                try? await Task.sleep(for: .seconds(Constants.readMoreAppearDelay))
                withAnimation(.easeInOut(duration: Constants.readMoreAppearAnimationDuration)) {
                    showReadMore = true
                }
            }
        } label: {
            Text(Strings.MovieDetails.hideMoreButtonText)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Constants
private extension HideMoreButton {
    enum Constants {
        static var readMoreAppearDelay: TimeInterval = 0.35
        static var readMoreAppearAnimationDuration: TimeInterval = 0.4
    }
}
