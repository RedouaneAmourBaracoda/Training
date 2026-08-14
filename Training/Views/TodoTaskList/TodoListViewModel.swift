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
    var uncompletedTasksCount: Int {
        todoListOrganizer.unCompletedTasksCounter
    }
    private let todoUseCase: TodoUseCaseType

    init(todoUseCase: TodoUseCaseType) {
        self.todoUseCase = todoUseCase
    }

    func loadTodos() async throws {
        let newList = try await todoUseCase.load()
        todoListOrganizer.update(with: newList)
    }

    func createTodo(name: String) async throws {
        let newTodoTask = try await todoUseCase.create(todoTaskName: name)
        todoListOrganizer.add(newTodoTask)
    }

    func update(_ todoTask: TodoTask) async throws {
        let updatedTodo = try await todoUseCase.update(
            todoTask: .init(
                id: todoTask.id,
                name: todoTask.name,
                isCompleted: todoTask.isCompleted ? false : true
            )
        )
        todoListOrganizer.update(todoTask: updatedTodo)
    }

    func delete(_ todoTask: TodoTask) {
        todoListOrganizer.delete(todoTask)
    }
}
