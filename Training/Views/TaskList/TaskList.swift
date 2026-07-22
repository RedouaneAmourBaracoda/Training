//
//  TaskList.swift
//  Training
//
//  Created by Redouane Amour on 22/07/2026.
//

import Foundation

struct TaskList {
    var tasks: [Task]

    init(tasks: [Task]) {
        self.tasks = tasks
        sort()
    }

    mutating func check(_ task: Task) {
        task.isCompleted ? moveUp(task) : moveDown(task)
    }

    mutating func add(_ name: String) {
        guard !tasks.contains(where: { $0.name == name }) else { return }
        let newTask: Task = .init(name: name, isCompleted: false)
        moveUp(newTask)
    }

    private mutating func sort() {
        tasks.sort { _, task in task.isCompleted }
    }

    private mutating func moveDown(_ task: Task) {
        tasks.removeAll { $0.name == task.name }
        tasks.append(.init(name: task.name, isCompleted: true))
    }

    private mutating func moveUp(_ task: Task) {
        tasks.removeAll { $0.name == task.name }
        tasks = [.init(name: task.name, isCompleted: false)] + tasks
    }
}
