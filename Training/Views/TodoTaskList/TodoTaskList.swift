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

    mutating func toggleCompletion(_ todoTask: TodoTask) {
        guard let index = todoTasks.firstIndex(where: { $0.id == todoTask.id }) else { return }
        todoTasks[index].toggleCompletion()
        sort()
    }

    mutating func add(_ newTodoTask: TodoTask) {
        todoTasks.append(newTodoTask)
        sort()
    }
    
    mutating func delete(_ todoTask: TodoTask) {
        todoTasks.removeAll { $0.id == todoTask.id }
        sort()
    }

    private mutating func sort() {
        todoTasks.sort { !$0.isCompleted && $1.isCompleted }
    }
}
