//
//  MainPresenterMock.swift
//  ToDoListTests
//
//  Created by Evgenii Mikhailov on 20.11.2024.
//

import Foundation

// Мок для MainScreenPresenterProtocol
final class MockMainScreenPresenter: MainScreenPresenterProtocol {
    var todos: [TaskModel] = []
    
    func fetchTasks() {}
    
    func didFailToLoadTasks(error: String) {}
    
    func todo(at index: Int) -> TaskModel { return todos[index] }
    
    func loadTasks() {}
    
    func didLoadTasks(tasks: [TaskModel]) {}
    
    func addNewTask() {}
    
    func didSelectTask(at index: Int) {}
    
    func didTapDeleteTask(at index: Int) {}
    
    func toggleTaskCompletion(at index: Int) {}
    
    func tasksCount() -> String { return ""}
    
    func perfomSearch(text: String) {}
    
    func didSearchTasks(tasks: [TaskModel]) {}
    
    func didSaveTasks() {}
    
    var didFetchTasksCalled = false
    var fetchedTasks: [TaskModel]?
    
    var didFailToFetchTasksCalled = false
    var fetchError: Error?
    
    func didFetchTasks(tasks: [TaskModel]) {
        didFetchTasksCalled = true
        fetchedTasks = tasks
    }
    
    func didFailToFetchTasks(error: Error) {
        didFailToFetchTasksCalled = true
        fetchError = error
    }
    
    // Реализуйте остальные методы протокола, если необходимо
}
