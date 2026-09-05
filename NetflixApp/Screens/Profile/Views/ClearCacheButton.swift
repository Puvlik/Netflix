import SwiftUI

// MARK: - ClearCacheButton
struct ClearCacheButton: View {
    var isClearingCache: Bool
    var isCacheClearedSuccessfully: Bool
    let buttonAction: (() -> Void)?
    
    private var buttonStrokeColor: Color {
        isCacheClearedSuccessfully ? Color.green : Color.gray.opacity(Constants.buttonDefaultStateStrokeColorOpacity)
    }

    var body: some View {
        Button {
            guard !isClearingCache, !isCacheClearedSuccessfully else { return }
            buttonAction?()
        } label: {
            ZStack {
                if isClearingCache {
                    ProgressView()
                        .tint(.white)
                } else if isCacheClearedSuccessfully {
                    HStack(spacing: Constants.clearedSuccessfullyStateStackSpacing) {
                        Image(systemName: Constants.checkmarkIconSystemName)
                        Text(Strings.Profile.clearCacheButtonSuccessfullyClearedTitle)
                    }
                    .foregroundColor(.green)
                } else {
                    Text(Strings.Profile.clearCacheButtonDefaultTitle)
                        .foregroundColor(.white)
                }
            }
            .font(.system(size: Constants.clearCacheButtonFontSize, weight: .bold))
            .frame(maxWidth: .infinity)
            .frame(height: Constants.clearCacheButtonHeight)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.clearCacheButtonCornerRadius)
                    .stroke(
                        buttonStrokeColor,
                        lineWidth: Constants.buttonBorderLineWidth
                    )
            )
            .animation(.easeInOut(duration: Constants.buttonStateChangeAnimationDuration), value: isClearingCache)
            .animation(
                .easeInOut(
                    duration: Constants.buttonStateChangeAnimationDuration
                ),
                value: isCacheClearedSuccessfully
            )
        }
        .padding(.horizontal)
    }
}

// MARK: - Constants
private extension ClearCacheButton {
    enum Constants {
        static var buttonBorderLineWidth: CGFloat = 2
        static var buttonDefaultStateStrokeColorOpacity: Double = 0.6
        static var clearedSuccessfullyStateStackSpacing: CGFloat = 8
        static var checkmarkIconSystemName: String = "checkmark.circle.fill"
        static var clearCacheButtonFontSize: CGFloat = 25
        static var clearCacheButtonHeight: CGFloat = 50
        static var clearCacheButtonCornerRadius: CGFloat = 12
        static var buttonStateChangeAnimationDuration: TimeInterval = 0.25
    }
}
