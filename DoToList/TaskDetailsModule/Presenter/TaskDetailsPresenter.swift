//
//  TaskDetailsPresenter.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import Foundation

protocol TaskDetailsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSave()
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
    
    func didTapSave() {
        router?.navigateBack()
    }
}
