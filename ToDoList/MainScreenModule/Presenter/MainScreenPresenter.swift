//
//  MainScreenPresenter.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import Foundation

protocol MainScreenPresenterProtocol: AnyObject {
    func didFetchTasks(tasks: [TaskModel])
    func fetchTasks()
    func didFailToFetchTasks(error: Error)
    func didFailToLoadTasks(error: String)
    var todos: [TaskModel] { get }
    func todo(at index: Int) -> TaskModel
    func loadTasks()
    func didLoadTasks(tasks: [TaskModel])
    func addNewTask()
    func didSelectTask(at index: Int)
    func toggleTaskCompletion(at index: Int)
    func tasksCount() -> String
}

final class MainScreenPresenter: MainScreenPresenterProtocol {
    
    func toggleComletion(at index: Int) {}
    
    weak var view: MainViewProtocol?
    var interactor: MainScreenInteractorProtocol?
    var router: MainScreenRouterProtocol?
    var todos: [TaskModel] = []
    
    func fetchTasks() {
        interactor?.fetchTasks()
    }
    
    func didFetchTasks(tasks: [TaskModel]) {
        todos = tasks
        view?.updateTableView(tasks: tasks)
    }
    
    func didFailToFetchTasks(error: Error) {
        print(error.localizedDescription)
    }
    
    func didFailToLoadTasks(error: String) {
        view?.showError(error: error)
    }
    
    func todo(at index: Int) -> TaskModel {
        return todos[index]
    }
    
    func loadTasks() {
        interactor?.loadTasks()
    }
    
    func didLoadTasks(tasks: [TaskModel]) {
        self.todos = tasks
        view?.updateTableView(tasks: tasks)
    }
    
    func addNewTask() {
        router?.navigateToAddNewTaskScreen()
    }
    
    func didSelectTask(at index: Int) {
        let task = todos[index]
        router?.navigateToTaskDetails(with: task)
    }
    
    func tasksCount() -> String {
        return todos.count.description
    }
    
    func toggleTaskCompletion(at index: Int) {
        todos[index].completed.toggle()
        let updatedTask = todos[index]
        interactor?.updateTask(task: updatedTask)
        view?.updateTableView(tasks: todos)
    }
}
