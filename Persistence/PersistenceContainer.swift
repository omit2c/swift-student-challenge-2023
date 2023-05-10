import SwiftUI
import CoreData

/// The persistence controller for Core Data
class Persistence {
    static let shared = Persistence()
    
    let container : NSPersistentContainer
    /// Load the used container with the database
    init(inMemory: Bool = false) {
        
        let container = NSPersistentContainer(name: "TeamModel", managedObjectModel: Persistence.createTeamModel())
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("failed with \(error.localizedDescription)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        self.container = container
    }
}
