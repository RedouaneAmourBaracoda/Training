//
//  TodoTask.swift
//  Training
//
//  Created by Redouane Amour on 15/07/2026.
//

import Foundation

struct TodoTask: Identifiable {
    let id: UUID
    let name: String
    var isCompleted: Bool
    
    init(id: UUID = .init(), name: String, isCompleted: Bool = false) {
        self.id = id
        self.name = name
        self.isCompleted = isCompleted
    }
    
    mutating func toggleCompletion() {
        isCompleted ? unComplete() : complete()
    }
    
    private mutating func complete() {
        isCompleted = true
    }
    
    private mutating func unComplete() {
        isCompleted = false
    }
}

extension TodoTask: Equatable {
    static func == (lhs: TodoTask, rhs: TodoTask) -> Bool {
        lhs.name == rhs.name && lhs.isCompleted == rhs.isCompleted
    }
}

extension TodoTask: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension Array<TodoTask> {
    static func random() -> Self {
        let randomTasks: Self = (0..<Int.random(in: 1...10)).map { _ in .random() }
        let uniqueTasks = Set(randomTasks)
        return Array(uniqueTasks)
    }
}

extension TodoTask {
    static func random() -> Self {
        .init(
            name: Resources.TodoTasks.dummies.randomElement() ?? Resources.TodoTasks.default,
            isCompleted: .random()
        )
    }
}
