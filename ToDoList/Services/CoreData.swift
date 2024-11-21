//
//  CoreData.swift
//  ToDoList
//
//  Created by Evgenii Mikhailov on 19.11.2024.
//

import Foundation
import CoreData

protocol CoreDataStackProtocol {
    var mainContext: NSManagedObjectContext { get }
    func newBackgroundContext() -> NSManagedObjectContext
    
}

class CoreDataStack: CoreDataStackProtocol {
    let persistentContainer: NSPersistentContainer
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Ошибка при загрузке хранилища: \(error)")
            }
        }
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}

public extension NSManagedObject {
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}
