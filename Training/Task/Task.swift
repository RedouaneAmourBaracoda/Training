//
//  Task.swift
//  Training
//
//  Created by Redouane Amour on 15/07/2026.
//

import Foundation

struct Task {
    let name: String
    let isDone: Bool
    
    init(name: String, isDone: Bool) {
        self.name = name
        self.isDone = isDone
    }
}

extension Task: Hashable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension Array<Task> {
    static func random() -> Self {
        let randomTasks: Self = (0..<Int.random(in: 1...10)).map { _ in .random() }
        let uniqueTasks = Set(randomTasks)
        return uniqueTasks.map { $0 }
    }
}

extension Task {
    static func random() -> Self {
        .init(
            name: Resources.tasks.dummies.randomElement() ?? Resources.tasks.default,
            isDone: .random()
        )
    }
}
