//
//  CoreData.swift
//  ToDoList
//
//  Created by Evgenii Mikhailov on 19.11.2024.
//

import Foundation
import CoreData

class TestCoreDataTestStack {
    let persistentContainer: NSPersistentContainer

    init() {
        persistentContainer = NSPersistentContainer(name: "DoToList") // Replace with your actual model name
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]

        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
    }

    var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
