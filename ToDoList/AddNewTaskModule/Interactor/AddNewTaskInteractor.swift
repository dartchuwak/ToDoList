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
    func saveTask(title: String, description: String)
}

final class AddNewTaskInteractor: AddNewTaskInteractorProtocol {
    weak var presenter: AddNewTaskPresenterProtocol?
    let coreData: CoreDataStack
    
    init(coreData: CoreDataStack) {
        self.coreData = coreData
    }
    
    func saveTask(title: String, description: String) {
        let context = coreData.newBackgroundContext()
        
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
                    self.presenter?.didSaveTask()
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailToSaveTask(error: error.localizedDescription)
                }
            }
        }
    }
}
