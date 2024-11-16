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
}

final class MainScreenInteractor: MainScreenInteractorProtocol {
    
    let api: APIProtocol = API() // DI
    weak var presenter: MainScreenPresenterProtocol?
    private var todos: [TaskModel] = []
    
    func fetchTasks() {
        api.fetchData { [weak self] result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let todoResponse = try decoder.decode(TasksResponse.self, from: data)
                    let todos = todoResponse.todos
                    self?.todos = todos
                    self?.presenter?.didFetchTasks(tasks: todos)
                } catch {
                    // Обрабатываем ошибку декодирования
                    self?.presenter?.didFailToFetchTasks(error: error)
                }
            case .failure:
                break
            }
        }
        
    }
    
    func loadTasks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            presenter?.didFailToLoadTasks(error: "Не удалось получить AppDelegate")
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        do {
            let tasks = try context.fetch(fetchRequest)
            let taskModels = tasks.map { taskEntity -> TaskModel in
                return TaskModel(
                    id: taskEntity.id,
                    desctiption: taskEntity.desctiption,
                    todo: taskEntity.todo ?? "",
                    completed: taskEntity.completed,
                    userId: taskEntity.userId,
                    date: taskEntity.date ?? ""
                )
            }
            presenter?.didLoadTasks(tasks: taskModels)
        } catch {
            presenter?.didFailToLoadTasks(error: error.localizedDescription)
        }
    }
    
    func updateTask(task: TaskModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Не удалось получить AppDelegate")
            //  presenter?.didFailToUpdateTask(error: "Не удалось получить AppDelegate")
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id.description)
        do {
            let results = try context.fetch(fetchRequest)
            if let taskEntity = results.first {
                taskEntity.completed = task.completed
                try context.save()
            }
        } catch {
            print(error)
            //      presenter?.didFailToUpdateTask(error: error.localizedDescription)
        }
    }
}
