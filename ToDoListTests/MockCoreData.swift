//
//  MockCoreData.swift
//  ToDoListTests
//
//  Created by Evgenii Mikhailov on 20.11.2024.
//

import Foundation
import CoreData


class MockCoreDataStack: CoreDataStackProtocol {
    private let persistentContainer: NSPersistentContainer
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init() {
        persistentContainer = NSPersistentContainer(name: "ToDoList")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Не удалось загрузить in-memory persistent store: \(error)")
            }
        }
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}
