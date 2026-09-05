import os
import SwiftUI

enum CachedImagePhase {
    case empty
    case success(Image)
    case failure
}

struct CachedImageView<Content: View>: View {
    let url: URL?
    @ViewBuilder let content: (CachedImagePhase) -> Content
    @Environment(\.imageLoader) private var imageLoader
    @State private var phase: CachedImagePhase = .empty
    
    var body: some View {
        if let url, let syncImage = imageLoader.cachedImage(for: url) {
            content(.success(syncImage))
        } else {
            content(phase)
                .task(id: url) {
                    await loadAsync()
                }
        }
    }
    
    @MainActor
    private func loadAsync() async {
        guard let url = url else {
            phase = .failure
            return
        }
        
        phase = .empty
        
        do {
            let image = try await imageLoader.loadImage(from: url)
            guard !Task.isCancelled else { return }
            withAnimation(.easeInOut(duration: Constants.stateTransactionDuration)) {
                phase = .success(image)
            }
        } catch let error {
            guard !Task.isCancelled else { return }
            AppLogger.network.error(
                "Failed to load movie image: \(error.localizedDescription)"
            )
            phase = .failure
        }
    }
}

// MARK: - Constants
private extension CachedImageView {
    enum Constants {
        static var stateTransactionDuration: TimeInterval { 0.25 }
    }
}
