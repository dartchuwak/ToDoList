//
//  ToDo.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 05.02.2025.
//

import Foundation

struct TaskModel: Decodable, Encodable {
    var id: Int16
    var description: String?
    var todo: String
    var completed: Bool
    var userId: Int16
    var date: String?
}

struct TasksResponse: Decodable, Encodable {
    let todos: [TaskModel]
    let total: Int
    let skip: Int
    let limit: Int
}

extension TaskModel {
    init(from entity: TaskEntity) {
        self.id = Int16(entity.id) // Преобразуем Int16 в Int
        self.description = entity.desc ?? "" // Проверяем, что это не nil
        self.todo = entity.todo ?? ""
        self.completed = entity.completed
        self.userId = Int16(entity.userId) // Преобразуем Int16 в Int
        self.date = entity.date ?? ""
    }
}
