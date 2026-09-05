import Alamofire
import SwiftUI

protocol ImageLoadingProtocol: Sendable {
    func loadImage(from url: URL) async throws -> Image
    func cachedImage(for url: URL) -> Image?
}

final class ImageLoaderService: ImageLoadingProtocol {
    private let cache: ImageCachingProtocol
    private let session: Alamofire.Session
    private let decoder = ImageDecoder()
    
    init(cache: ImageCachingProtocol, session: Alamofire.Session = .default) {
        self.cache = cache
        self.session = session
    }
    
    func cachedImage(for url: URL) -> Image? {
        guard let uiImage = cache.memoryImage(for: url) else { return nil }
        return Image(uiImage: uiImage)
    }
    
    func loadImage(from url: URL) async throws -> Image {
        if let memoryImage = cache.memoryImage(for: url) {
            return Image(uiImage: memoryImage)
        }
        
        try Task.checkCancellation()
        if let diskData = await cache.loadImageData(for: url),
           let uiImage = await decoder.decode(diskData) {
            cache.saveToMemoryCache(uiImage, for: url)
            return Image(uiImage: uiImage)
        }
        
        try Task.checkCancellation()
        let request = session.request(url).validate().serializingData()
        let data = try await request.value
        try Task.checkCancellation()
        
        guard let downloadedImage = await decoder.decode(data) else {
            throw URLError(.cannotDecodeRawData)
        }

        let localCache = cache
        Task.detached(priority: .background) {
            try? await localCache.saveImage(data: data, for: url)
        }
        
        cache.saveToMemoryCache(downloadedImage, for: url)
        return Image(uiImage: downloadedImage)
    }
}
