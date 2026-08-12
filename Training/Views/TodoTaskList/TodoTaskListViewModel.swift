//
//  File.swift
//  Training
//
//  Created by Redouane Amour on 15/07/2026.
//

import Combine
import Foundation

@MainActor
final class TodoTaskListViewModel: ObservableObject {
    @Published private(set) var list: TodoTaskList = .init(todoTasks: [])
    @Published private(set) var isLoading : Bool = false
    var uncompletedTasksCount: Int {
        list.unCompletedTasksCount
    }
    private let addTodoUseCase: AddTodoUseCaseType
    private let loadTodoUseCase: LoadTodoUseCaseType

    init(addTodoUseCase: AddTodoUseCaseType, loadTodoUseCase: LoadTodoUseCaseType) {
        self.addTodoUseCase = addTodoUseCase
        self.loadTodoUseCase = loadTodoUseCase
    }

    func loadTodos() async throws {
        isLoading = true
        let todoTasks = try await loadTodoUseCase.load()
        todoTasks.forEach { list.add($0) }
        isLoading = false
    }

    func save(todoTaskName: String) async throws {
        isLoading = true
        let newTodoTask = try await addTodoUseCase.create(todoTaskName: todoTaskName)
        list.add(newTodoTask)
        isLoading = false
    }

    func delete(_ todoTask: TodoTask) {
        list.delete(todoTask)
    }
    
    func toggleCompletion(_ todoTask: TodoTask) {
        list.toggleCompletion(todoTask)
    }
}

