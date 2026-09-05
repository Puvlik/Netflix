import CoreData
import Foundation
import os

// MARK: - Garbage Collector
extension CoreDataService: CoreDataGarbageCollectorProtocol {
    func runGarbageCollector() async {
        await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "isPopular == NO AND isComingSoon == NO AND isFavorite == NO AND parentMovies.@count == 0"
            )
            
            let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDelete.resultType = .resultTypeObjectIDs
            
            do {
                let result = try context.execute(batchDelete) as? NSBatchDeleteResult
                if let objectIDArray = result?.result as? [NSManagedObjectID], !objectIDArray.isEmpty {
                    self.scheduleViewContextMerge(of: objectIDArray)
                }
            } catch let error {
                AppLogger.coreData.error(
                    "CoreDataService runGarbageCollector failed with error: \(error.localizedDescription)"
                )
            }
        }
    }
    
    private func scheduleViewContextMerge(of deletedObjectIDs: [NSManagedObjectID]) {
        let viewContext = container.viewContext
        let changes = [NSDeletedObjectsKey: deletedObjectIDs]
        viewContext.perform {
            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: changes as [AnyHashable: Any],
                into: [viewContext]
            )
        }
    }
}

// MARK: - Core Data Cache Clearing
extension CoreDataService: CoreDataCacheClearingProtocol {
    func getFavoriteMovieImagePaths() async throws -> Set<String> {
        try await container.performBackgroundTask { context in
            let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "MovieEntity")
            fetchRequest.predicate = NSPredicate(format: "isFavorite == YES")
            fetchRequest.resultType = .dictionaryResultType
            fetchRequest.propertiesToFetch = ["posterPath", "backdropPath"]
            
            let favoriteMovies = try context.fetch(fetchRequest)
            var filesToKeep = Set<String>()
            for movieDict in favoriteMovies {
                if let poster = movieDict["posterPath"] as? String {
                    filesToKeep.insert((poster as NSString).lastPathComponent)
                }
                
                if let backdrop = movieDict["backdropPath"] as? String {
                    filesToKeep.insert((backdrop as NSString).lastPathComponent)
                }
            }
            return filesToKeep
        }
    }

    func clearLocalCache() async throws {
        try await container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isFavorite == NO")
            let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDelete.resultType = .resultTypeObjectIDs
            
            let result = try context.execute(batchDelete) as? NSBatchDeleteResult
            if let objectIDArray = result?.result as? [NSManagedObjectID], !objectIDArray.isEmpty {
                self.scheduleViewContextMerge(of: objectIDArray)
            }
        }
    }
}
