//
//  TodoDTO.swift
//  Training
//
//  Created by Redouane Amour on 09/08/2026.
//

import Foundation

struct TodoRequestDTO: Encodable {
    let name: String
    let description: String
}

struct TodoResponseDTO: Decodable {
    let id: Int
    let name: String
    let status: Bool

    var toTodoTask: TodoTask { .init(id: id, name: name, isCompleted: status) }
}

extension Array<TodoResponseDTO> {
    var toTodoList: [TodoTask] { map { $0.toTodoTask } }
}
