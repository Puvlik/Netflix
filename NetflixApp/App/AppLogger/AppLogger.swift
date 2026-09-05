import Foundation
import os

enum AppLogger {
    private nonisolated static let subsystem = Bundle.main.bundleIdentifier ?? "com.pashaklopat.NetflixApp"
    nonisolated static let coreData = Logger(subsystem: subsystem, category: "CoreData")
    nonisolated static let network  = Logger(subsystem: subsystem, category: "Network")
    nonisolated static let fileManager = Logger(subsystem: subsystem, category: "FileManager")
}
