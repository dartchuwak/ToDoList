//
//  TaskDetailsInteractor.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import Foundation
import UIKit
import CoreData

protocol TaskDetailsInteractorProtocol {
    func updateTask(task: TaskModel)
}

final class TaskDetailsInteractor: TaskDetailsInteractorProtocol {
    weak var presenter: TaskDetailsPresenterProtocol?
    let coreData: CoreDataStack
    
    init(coreData: CoreDataStack) {
        self.coreData = coreData
    }
    
    func updateTask(task: TaskModel) {
        
        let context = coreData.newBackgroundContext()
        
        context.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", task.id.description)
            do {
                let results = try context.fetch(fetchRequest)
                if let taskEntity = results.first {
                    taskEntity.desc = task.description
                    taskEntity.todo = task.todo
                    try context.save()
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailToUpdateTask(error: error.localizedDescription)
                }
            }
        }
    }
}
