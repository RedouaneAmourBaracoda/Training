//
//  TodoDTO.swift
//  Training
//
//  Created by Redouane Amour on 09/08/2026.
//

import Foundation

struct CreateTodoDTO: Encodable {
    let name: String
    let description: String
}

struct TodosResponseDTO: Decodable {
    let todos: [TodoResponseDTO]
    let total: Int
    let skip: Int
    let limit: Int

    var toTodoTasks: [TodoTask] { todos.map { $0.toTodoTask }}
}

struct TodoResponseDTO: Decodable {
    let id: Int
    let name: String
    let description: String
    let status: Bool
    
    var toTodoTask: TodoTask { .init(id: id, name: name, isCompleted: status)}
}
