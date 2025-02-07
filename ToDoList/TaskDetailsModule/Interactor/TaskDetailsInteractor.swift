//
//  TaskDetailsInteractor.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 05.02.2025.
//

import Foundation
import UIKit
import CoreData

protocol TaskDetailsInteractorProtocol {
    func updateTask(task: TaskModel)
}

final class TaskDetailsInteractor: TaskDetailsInteractorProtocol {
    weak var presenter: TaskDetailsPresenterProtocol?
    private let coreDataManager: CoreDataManagerProtocol
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
    
    func updateTask(task: TaskModel) {
        do {
            try coreDataManager.updateTask(task: task)
        } catch {
            presenter?.didFailToUpdateTask(error: error.localizedDescription)
        }
    }
}
