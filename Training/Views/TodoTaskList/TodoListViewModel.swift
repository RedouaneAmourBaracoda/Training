//
//  File.swift
//  Training
//
//  Created by Redouane Amour on 15/07/2026.
//

import Combine
import Foundation

@MainActor
final class TodoListViewModel: ObservableObject {
    @Published private(set) var todoListOrganizer: TodoListOrganizer = .init(list: [])
    @Published private(set) var isLoading : Bool = false
    var uncompletedTasksCount: Int {
        todoListOrganizer.unCompletedTasksCounter
    }
    private let todoUseCase: TodoUseCaseType

    init(todoUseCase: TodoUseCaseType) {
        self.todoUseCase = todoUseCase
    }

    func loadTodos() async throws {
        isLoading = true
        let todoTasks = try await todoUseCase.load()
        todoTasks.forEach { todoListOrganizer.add($0) }
        isLoading = false
    }

    func createTodo(name: String) async throws {
        isLoading = true
        let newTodoTask = try await todoUseCase.create(todoTaskName: name)
        todoListOrganizer.add(newTodoTask)
        isLoading = false
    }

    func delete(_ todoTask: TodoTask) {
        todoListOrganizer.delete(todoTask)
    }
    
    func toggleCompletion(_ todoTask: TodoTask) {
        todoListOrganizer.toggleCompletion(todoTask)
    }
}

