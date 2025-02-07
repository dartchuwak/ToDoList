//
//  MockCoreData.swift
//  ToDoListTests
//
//  Created by Evgenii Mikhailov on 20.11.2024.
//

import Foundation
import CoreData


final class MockCoreDataStack: CoreDataStackProtocol {
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

final class MockCOreDataManager: CoreDataManagerProtocol {
    func fetchTasks() throws -> [TaskEntity] {
        return []
    }
    
    func updateTask(task: TaskModel) throws {
        
    }
    
    func deleteTask(_ task: TaskModel) throws {
        
    }
    
    func searchTasks(withText text: String) throws -> [TaskEntity] {
        []
    }
    
    func saveTask(title: String, description: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        
    }
    
    
}
