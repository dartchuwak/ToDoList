//
//  MainScreenInteractor.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import Foundation
import CoreData
import UIKit

protocol MainScreenInteractorProtocol {
    func fetchTasks()
    func loadTasks()
    func updateTask(task: TaskModel)
    func performSearch(text: String)
    func deleteTask(task: TaskModel)
}

final class MainScreenInteractor: MainScreenInteractorProtocol {
    private let networkService: NetworkServiceProtocol
    private let coreData: CoreDataStackProtocol
    weak var presenter: MainScreenPresenterProtocol?
    private var todos: [TaskModel] = []
    private let coreDataManager: CoreDataManagerProtocol
    
    init(coreData: CoreDataStackProtocol, networkService: NetworkServiceProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.coreData = coreData
        self.networkService = networkService
        self.coreDataManager = coreDataManager
    }
    
    func fetchTasks() {
        networkService.fetchData(url: Endpoints.todos) { [weak self] result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let todoResponse = try decoder.decode(TasksResponse.self, from: data)
                    let todos = todoResponse.todos
                    self?.todos = todos
                    self?.saveFetchedTasks(tasks: todos)
                    DispatchQueue.main.async {
                        self?.presenter?.didFetchTasks(tasks: todos)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.presenter?.didFailToFetchTasks(error: error)
                    }
                }
            case .failure(let error):
                self?.presenter?.didFailToFetchTasks(error: error)
                return
            }
        }
    }
    
    private func saveFetchedTasks(tasks: [TaskModel]) {
        let context = coreData.newBackgroundContext()
        context.perform {
            for todo in tasks {
                do {
                    let task = TaskEntity(context: context)
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yy"
                    let formattedDate = formatter.string(from: date)
                    task.id = Int16(todo.id)
                    task.todo = todo.todo
                    task.desc = todo.description
                    task.date = formattedDate
                    task.completed = todo.completed
                    try context.save()
                } catch { }
            }
        }
    }
    
    func loadTasks() {
        do {
            let taskEntities = try coreDataManager.fetchTasks()
            let taskModels = taskEntities.map { TaskModel(from: $0) }
            presenter?.didLoadTasks(tasks: taskModels)
        } catch {
            presenter?.didFailToLoadTasks(error: error.localizedDescription)
        }
    }
    
    func updateTask(task: TaskModel) {
        do {
            try coreDataManager.updateTask(task: task)
        } catch {
            print("Failed to update task: \(error)")
        }
    }
    
    func performSearch(text: String) {
        do {
            let taskEntities = try coreDataManager.searchTasks(withText: text)
            let taskModels = taskEntities.map { TaskModel(from: $0) }
            presenter?.didSearchTasks(tasks: taskModels)
        } catch {
            presenter?.didFailToLoadTasks(error: error.localizedDescription)
        }
    }
    
    func deleteTask(task: TaskModel) {
        do {
            try coreDataManager.deleteTask(task)
        } catch {
            print("Failed to delete task: \(error)")
        }
    }
}
