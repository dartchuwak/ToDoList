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
    
    init(coreData: CoreDataStackProtocol, networkService: NetworkServiceProtocol) {
        self.coreData = coreData
        self.networkService = networkService
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
        let context = coreData.newBackgroundContext()
        context.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            do {
                let tasks = try context.fetch(fetchRequest)
                let taskModels = tasks.map { taskEntity -> TaskModel in
                    return TaskModel(
                        id: taskEntity.id,
                        description: taskEntity.desc,
                        todo: taskEntity.todo ?? "",
                        completed: taskEntity.completed,
                        userId: taskEntity.userId,
                        date: taskEntity.date ?? ""
                    )
                }
                DispatchQueue.main.async {
                    self.presenter?.didLoadTasks(tasks: taskModels)
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailToLoadTasks(error: error.localizedDescription)
                }
            }
        }
    }
    
    func updateTask(task: TaskModel) {
        let backgroundContext = coreData.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", task.id.description)
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let taskEntity = results.first {
                    taskEntity.completed = task.completed
                    try backgroundContext.save()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func performSearch(text: String) {
        let backgroundContext = coreData.newBackgroundContext()
        
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "todo CONTAINS[cd] %@ OR desc CONTAINS[cd] %@", text, text)
            
            do {
                let tasks = try backgroundContext.fetch(fetchRequest)
                let taskModels = tasks.map { taskEntity -> TaskModel in
                    return TaskModel(
                        id: taskEntity.id,
                        description: taskEntity.desc,
                        todo: taskEntity.todo ?? "",
                        completed: taskEntity.completed,
                        userId: taskEntity.userId,
                        date: taskEntity.date ?? Date().description
                    )
                }
                DispatchQueue.main.async {
                    self.presenter?.didSearchTasks(tasks: taskModels)
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailToLoadTasks(error: error.localizedDescription)
                }
            }
        }
    }
    
    func deleteTask(task: TaskModel) {
        let backgroundContext = coreData.newBackgroundContext()
        
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", task.id.description)
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let taskEntity = results.first {
                    backgroundContext.delete(taskEntity)
                    try backgroundContext.save()
                }
            } catch {
                print(error)
            }
        }
    }
}
