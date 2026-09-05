import SwiftUI

private struct ImageLoaderKey: EnvironmentKey {
    static let defaultValue: ImageLoadingProtocol = ImageLoaderService(cache: LocalImageCacheManager())
}

extension EnvironmentValues {
    var imageLoader: ImageLoadingProtocol {
        get { self[ImageLoaderKey.self] }
        set { self[ImageLoaderKey.self] = newValue }
    }
}
