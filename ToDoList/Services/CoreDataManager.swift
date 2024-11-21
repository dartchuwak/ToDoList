//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Evgenii Mikhailov on 21.11.2024.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    func fetchTasks() throws -> [TaskEntity]
    func updateTask(task: TaskModel) throws
    func deleteTask(_ task: TaskModel) throws
    func searchTasks(withText text: String) throws -> [TaskEntity]
    func saveTask(title: String, description: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class CoreDataManager: CoreDataManagerProtocol {
    private let coreDataStack: CoreDataStackProtocol
    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }
    
    func saveTask(title: String, description: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = coreDataStack.newBackgroundContext()
        context.perform {
            let task = TaskEntity(context: context)
            let id = Int.random(in: 1...1000)
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            let formattedDate = formatter.string(from: date)
            
            task.id = Int16(id)
            task.todo = title
            task.desc = description
            task.date = formattedDate
            task.completed = false
            
            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchTasks() throws -> [TaskEntity] {
        let context = coreDataStack.newBackgroundContext()
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        return try context.fetch(fetchRequest)
    }
    
    func updateTask(task: TaskModel) throws {
        let context = coreDataStack.newBackgroundContext()
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
        if let taskEntity = try context.fetch(fetchRequest).first {
            taskEntity.completed = task.completed
            taskEntity.todo = task.todo
            taskEntity.desc = task.description
            try context.save()
        }
    }
    
    func deleteTask(_ task: TaskModel) throws {
        let context = coreDataStack.newBackgroundContext()
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
        if let taskEntity = try context.fetch(fetchRequest).first {
            context.delete(taskEntity)
            try context.save()
        }
    }
    
    func searchTasks(withText text: String) throws -> [TaskEntity] {
        let context = coreDataStack.newBackgroundContext()
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "todo CONTAINS[cd] %@ OR desc CONTAINS[cd] %@", text, text)
        return try context.fetch(fetchRequest)
    }
}
