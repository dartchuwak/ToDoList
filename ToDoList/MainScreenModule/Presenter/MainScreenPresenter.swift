//
//  MainScreenPresenter.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 05.02.2025.
//

import Foundation

protocol MainScreenPresenterProtocol: AnyObject {
    var todos: [TaskModel] { get }
    func didFetchTasks(tasks: [TaskModel])
    func fetchTasks()
    func didFailToFetchTasks(error: Error)
    func didFailToLoadTasks(error: String)
    func todo(at index: Int) -> TaskModel
    func loadTasks()
    func didLoadTasks(tasks: [TaskModel])
    func addNewTask()
    func didSelectTask(at index: Int)
    func didTapDeleteTask(at index: Int)
    func toggleTaskCompletion(at index: Int)
    func tasksCount() -> String
    func perfomSearch(text: String)
    func didSearchTasks(tasks: [TaskModel])
    func didSaveTasks()
}

final class MainScreenPresenter: MainScreenPresenterProtocol {
    func toggleComletion(at index: Int) {}
    weak var view: MainViewProtocol?
    var interactor: MainScreenInteractorProtocol?
    var router: MainScreenRouterProtocol?
    var todos: [TaskModel] = []
    private var allTasks: [TaskModel] = []
    
    private func isFirstLaunch() -> Bool {
        let userDefaults = UserDefaults.standard
        let hasLaunchedKey = "hasLaunchedBefore"
        
        if !userDefaults.bool(forKey: hasLaunchedKey) {
            userDefaults.set(true, forKey: hasLaunchedKey)
            userDefaults.synchronize()
            return true
        }
        return false
    }
    
    func fetchTasks() {
        if isFirstLaunch() {
            interactor?.fetchTasks()
        }
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
        self.allTasks = tasks // Cохраняю для восстановления после поиска
        view?.updateTableView(tasks: tasks)
        view?.updateTaskCountLabel(count: todos.count)
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
    
    func perfomSearch(text: String) {
        if text.isEmpty {
            todos = allTasks // Восстанавливаю после поиска
            view?.updateTableView(tasks: todos)
            view?.updateTaskCountLabel(count: todos.count)
        } else {
            interactor?.performSearch(text: text)
        }
    }
    
    func didSearchTasks(tasks: [TaskModel]) {
        todos = tasks
        view?.updateTableView(tasks: todos)
        view?.updateTaskCountLabel(count: todos.count)
    }
    
    func didTapDeleteTask(at index: Int) {
        let task = todos[index]
        todos.removeAll(where: {$0.id == task.id})
        view?.updateTableView(tasks: todos)
        view?.updateTaskCountLabel(count: todos.count)
        interactor?.deleteTask(task: task)
    }
    
    func didSaveTasks() {
        loadTasks()
        view?.updateTableView(tasks: todos)
    }
}
