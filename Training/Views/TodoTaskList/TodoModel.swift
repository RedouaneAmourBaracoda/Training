//
//  TodoTaskList.swift
//  Training
//
//  Created by Redouane Amour on 22/07/2026.
//

import Foundation

struct TodoListOrganizer {
    private(set) var list: [TodoTask]

    var unCompletedTasksCounter: Int {
        list.filter { !$0.isCompleted }.count
    }

    init(list: [TodoTask]) {
        self.list = list
        sort()
    }

    mutating func toggleCompletion(_ todoTask: TodoTask) {
        guard let index = list.firstIndex(where: { $0.id == todoTask.id }) else { return }
        list[index].toggleCompletion()
        sort()
    }
    
    mutating func update(with newList: [TodoTask]) {
        list = newList
        sort()
    }

    mutating func add(_ newTodo: TodoTask) {
        list.append(newTodo)
        sort()
    }
    
    mutating func delete(_ todoTask: TodoTask) {
        list.removeAll { $0.id == todoTask.id }
        sort()
    }

    private mutating func sort() {
        list.sort { !$0.isCompleted && $1.isCompleted }
    }
}

struct TodoTask: Identifiable {
    let id: Int
    let name: String
    var isCompleted: Bool
    
    init(id: Int, name: String, isCompleted: Bool = false) {
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
            id: Int.random(in: 0...1000),
            name: Resources.TodoTasks.dummies.randomElement() ?? Resources.TodoTasks.default,
            isCompleted: .random()
        )
    }
}
