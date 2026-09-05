import CoreData
import Foundation
import os

final class CoreDataStack {
    let persistentContainer: NSPersistentContainer

    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "NetflixApp")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores { [weak self] description, error in
            guard let self else { return }
            if let error = error as NSError? {
                AppLogger.coreData.fault(
                    "Failed to load Core Data stack: \(error.localizedDescription), \(error.userInfo)"
                )
                
                guard let url = description.url else { return }
                do {
                    try self.persistentContainer.persistentStoreCoordinator.destroyPersistentStore(
                        at: url,
                        ofType: NSSQLiteStoreType,
                        options: nil
                    )

                    self.persistentContainer.loadPersistentStores { _, retryError in
                        if let retryError = retryError {
                            AppLogger.coreData.fault("Critical failure. Failed to recreate database: \(retryError)")
                        }
                    }
                } catch {
                    AppLogger.coreData.fault("Failed to delete database: \(error)")
                }
            }
        }
        
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        viewContext.perform { [weak self] in
            guard let self, viewContext.hasChanges else { return }
            do {
                try viewContext.save()
            } catch {
                AppLogger.coreData.error(
                    "Failed to save viewContext with error: \(error.localizedDescription)"
                )
            }
        }
    }
}
