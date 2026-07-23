//
//  TodoTaskList.swift
//  Training
//
//  Created by Redouane Amour on 22/07/2026.
//

import Foundation

struct TodoTaskList {
    private(set) var todoTasks: [TodoTask]

    var unCompletedTasksCount: Int {
        todoTasks.filter { !$0.isCompleted }.count
    }

    init(todoTasks: [TodoTask]) {
        self.todoTasks = todoTasks
        sort()
    }

    mutating func check(_ todoTask: TodoTask) {
        todoTask.isCompleted ? moveUp(todoTask) : moveDown(todoTask)
    }

    mutating func add(_ name: String) {
        guard !todoTasks.contains(where: { $0.name == name }) else { return }
        let newTodoTask: TodoTask = .init(name: name, isCompleted: false)
        moveUp(newTodoTask)
    }
    
    mutating func delete(_ todoTask: TodoTask) {
        todoTasks.removeAll { $0.id == todoTask.id }
    }

    private mutating func sort() {
        todoTasks.sort { !$0.isCompleted && $1.isCompleted }
    }

    private mutating func moveDown(_ todoTask: TodoTask) {
        todoTasks.removeAll { $0.name == todoTask.name }
        todoTasks.append(.init(name: todoTask.name, isCompleted: true))
    }

    private mutating func moveUp(_ todoTask: TodoTask) {
        todoTasks.removeAll { $0.name == todoTask.name }
        todoTasks = [.init(name: todoTask.name, isCompleted: false)] + todoTasks
    }
}
