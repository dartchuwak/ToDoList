//
//  TaskDetailsPresenter.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 05.02.2025.
//

import Foundation

protocol TaskDetailsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func updateTask(description: String?, todo: String?)
    func didFailToUpdateTask(error: String)
}

final class TaskDetailsPresenter: TaskDetailsPresenterProtocol {
    weak var view: TaskDetailsViewProtocol?
    var interactor: TaskDetailsInteractorProtocol?
    var router: TaskDetailsRouterProtocol?
    private var task: TaskModel
    
    init(task: TaskModel) {
        self.task = task
    }
    
    func viewDidLoad() {
        view?.displayTask(task)
    }
    
    func updateTask(description: String?, todo: String?) {
        self.task.description = description ?? ""
        self.task.todo = todo ?? ""
        interactor?.updateTask(task: self.task)
    }
    
    func didFailToUpdateTask(error: String) {
        print(error)
    }
}
