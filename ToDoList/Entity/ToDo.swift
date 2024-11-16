//
//  ToDo.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import Foundation

struct TaskModel: Decodable {
    var id: Int16
    var desctiption: String?
    var todo: String
    var completed: Bool
    var userId: Int16
    var date: String
}

struct TasksResponse: Decodable {
    let todos: [TaskModel]
    let total: Int
    let skip: Int
    let limit: Int
}
