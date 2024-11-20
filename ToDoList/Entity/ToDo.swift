//
//  ToDo.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import Foundation

struct TaskModel: Codable {
    var id: Int16
    var description: String?
    var todo: String
    var completed: Bool
    var userId: Int16
    var date: String?
}

struct TasksResponse: Codable {
    let todos: [TaskModel]
    let total: Int
    let skip: Int
    let limit: Int
}
