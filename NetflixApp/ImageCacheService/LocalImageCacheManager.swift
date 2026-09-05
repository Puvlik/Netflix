import SwiftUI

// MARK: - ImageCachingProtocol
protocol ImageCachingProtocol: Sendable {
    func saveImage(data: Data, for url: URL) async throws
    func loadImageData(for url: URL) async -> Data?
    func clearCache(except filesToKeep: Set<String>) async throws
    func memoryImage(for url: URL) -> UIImage?
    func saveToMemoryCache(_ image: UIImage, for url: URL)
}

// MARK: - LocalImageCacheManager
final class LocalImageCacheManager: ImageCachingProtocol {
    private let memoryCache = NSCache<NSString, UIImage>()
    private let storage = ImageDiskStorage(directoryName: Constants.cacheDirectoryName)

    init() {
        memoryCache.countLimit = Constants.cacheImagesLimit
    }
    
    func memoryImage(for url: URL) -> UIImage? {
        memoryCache.object(forKey: url.absoluteString as NSString)
    }
    
    func saveToMemoryCache(_ image: UIImage, for url: URL) {
        memoryCache.setObject(image, forKey: url.absoluteString as NSString)
    }
    
    func saveImage(data: Data, for url: URL) async throws {
        try await storage.save(data, for: url)
    }

    func loadImageData(for url: URL) async -> Data? {
        await storage.data(for: url)
    }
    
    func clearCache(except filesToKeep: Set<String>) async throws {
        memoryCache.removeAllObjects()
        try await storage.removeFiles(except: filesToKeep)
    }
}

// MARK: - Constants
private extension LocalImageCacheManager {
    enum Constants {
        static var cacheImagesLimit: Int = 100
        static let cacheDirectoryName: String = "MoviesImageCache"
    }
}
