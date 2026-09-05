import Foundation

actor ImageDiskStorage {
    private let directoryName: String
    private var cachedDirectory: URL?

    init(directoryName: String) {
        self.directoryName = directoryName
    }

    func save(_ data: Data, for url: URL) throws {
        let fileURL = try fileURL(for: url)
        try data.write(to: fileURL, options: .atomic)
    }

    func data(for url: URL) -> Data? {
        guard let fileURL = try? fileURL(for: url) else { return nil }
        return try? Data(contentsOf: fileURL)
    }

    func removeFiles(except filesToKeep: Set<String>) throws {
        let fileManager = FileManager.default
        let directory = try getDirectoryURL()
        guard fileManager.fileExists(atPath: directory.path) else { return }

        let allFiles = try fileManager.contentsOfDirectory(atPath: directory.path)
        for fileName in allFiles {
            let originalFileName = fileName.components(separatedBy: "~").last ?? fileName
            guard !filesToKeep.contains(originalFileName) else { continue }
            try? fileManager.removeItem(at: directory.appendingPathComponent(fileName))
        }
    }

    private func getDirectoryURL() throws -> URL {
        if let cachedDirectory {
            return cachedDirectory
        }

        let fileManager = FileManager.default
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        guard let root = caches.first else {
            throw CocoaError(.fileNoSuchFile)
        }

        let directory = root.appendingPathComponent(directoryName)
        if !fileManager.fileExists(atPath: directory.path) {
            try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        }

        cachedDirectory = directory
        return directory
    }

    private func fileURL(for url: URL) throws -> URL {
        let directory = try getDirectoryURL()
        let encoded = url.absoluteString.data(using: .utf8)?.base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: "") ?? UUID().uuidString
        return directory.appendingPathComponent("\(encoded)~\(url.lastPathComponent)")
    }
}
