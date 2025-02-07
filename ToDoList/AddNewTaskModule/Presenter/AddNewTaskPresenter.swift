//
//  AddNewTaskPresenter.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 05.02.2025.
//

import Foundation

protocol AddNewTaskPresenterProtocol: AnyObject {
    func saveNewTask(title: String?, description: String?)
    func didSaveTask()
    func didFailToSaveTask(error: String)
    func prepareDate()
}

final class AddNewTaskPresenter: AddNewTaskPresenterProtocol {
    weak var view: AddNewTaskScreenViewController?
    var interactor: AddNewTaskInteractorProtocol?
    var router: AddNewTaskRouterProtocol?
    
    func saveNewTask(title: String?, description: String?) {
        interactor?.saveTask(title: title ?? "", description: description ?? "")
    }
    
    func didSaveTask() {
        view?.showSuccess()
        router?.navigateBack()
    }
    
    func didFailToSaveTask(error: String) {
        view?.showError(error)
    }
    
    func prepareDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let formattedDate = formatter.string(from: date)
        view?.setDate(date: formattedDate)
    }
}
