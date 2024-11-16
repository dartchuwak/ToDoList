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
    
    func updateTask(task: TaskModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Не удалось получить AppDelegate")
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id.description)
        do {
            let results = try context.fetch(fetchRequest)
            if let taskEntity = results.first {
                taskEntity.desctiption = task.desctiption
                taskEntity.todo = task.todo
                try context.save()
            }
        } catch {
            print(error)
                  presenter?.didFailToUpdateTask(error: error.localizedDescription)
        }
    }
}
