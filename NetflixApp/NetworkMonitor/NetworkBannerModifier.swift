import SwiftUI

struct NetworkBannerModifier: ViewModifier {
    @Environment(NetworkMonitorService.self) private var networkMonitor

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            
            if networkMonitor.status == .disconnected {
                NoNetworkBannerView()
                    .padding(.top, Constants.bannerTopPadding)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .animation(
            .spring(
                response: Constants.bannerAnimationDuration,
                dampingFraction: Constants.bannerAnimationDampingFraction
            ),
            value: networkMonitor.status == .disconnected
        )
    }
}

// MARK: - Constants
private extension NetworkBannerModifier {
    enum Constants {
        static var bannerTopPadding: CGFloat = 8
        static var bannerAnimationDuration: Double = 0.4
        static var bannerAnimationDampingFraction: Double = 0.7
    }
}
