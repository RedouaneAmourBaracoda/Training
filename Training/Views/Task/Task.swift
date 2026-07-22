//
//  Task.swift
//  Training
//
//  Created by Redouane Amour on 15/07/2026.
//

import Foundation

struct Task: Identifiable {
    let id: UUID = .init()
    let name: String
    let isCompleted: Bool
    
    init(name: String, isCompleted: Bool) {
        self.name = name
        self.isCompleted = isCompleted
    }
}

extension Task: Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.name == rhs.name
    }
}

extension Task: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension Array<Task> {
    static func random() -> Self {
        let randomTasks: Self = (0..<Int.random(in: 1...10)).map { _ in .random() }
        let uniqueTasks = Set(randomTasks)
        return Array(uniqueTasks)
    }
}

extension Task {
    static func random() -> Self {
        .init(
            name: Resources.tasks.dummies.randomElement() ?? Resources.tasks.default,
            isCompleted: .random()
        )
    }
}
