//
//  AddNewTaskPresenter.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import Foundation

protocol AddNewTaskPresenterProtocol: AnyObject {
    func saveNewTask(title: String, description: String)
    func didSaveTask()
    func didFailToSaveTask(error: String)
}

final class AddNewTaskPresenter: AddNewTaskPresenterProtocol {
    weak var view: AddNewTaskScreenViewController?
    var interactor: AddNewTaskInteractorProtocol?
    var router: AddNewTaskRouterProtocol?
    
    func saveNewTask(title: String, description: String) {
        let date = Date().description
        interactor?.saveTask(title: title, description: description, date: date)
    }
    
    func didSaveTask() {
        view?.showSuccess()
        router?.navigateBack()
    }
    
    func didFailToSaveTask(error: String) {
        view?.showError(error)
    }
}
