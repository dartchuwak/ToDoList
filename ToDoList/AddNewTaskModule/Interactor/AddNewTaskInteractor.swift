//
//  AddNewTaskInteractor.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import Foundation
import UIKit
import CoreData

protocol AddNewTaskInteractorProtocol: AnyObject {
    func saveTask(title: String, description: String, date: String)
}

final class AddNewTaskInteractor: AddNewTaskInteractorProtocol {
    weak var presenter: AddNewTaskPresenterProtocol?
    
    
    func saveTask(title: String, description: String, date: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              presenter?.didFailToSaveTask(error: "Не удалось получить AppDelegate")
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let task = TaskEntity(context: context)
        let id = Int.random(in: 1...1000)
        task.id = Int16(id)
        task.todo = title
        task.desctiption = description
        task.date = date
        task.completed = false
        do {
            try context.save()
            presenter?.didSaveTask()
        } catch {
            presenter?.didFailToSaveTask(error: error.localizedDescription)
        }
    }
}
