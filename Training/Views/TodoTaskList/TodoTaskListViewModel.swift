//
//  File.swift
//  Training
//
//  Created by Redouane Amour on 15/07/2026.
//

import Combine
import Foundation

final class TodoTaskListViewModel: ObservableObject {
    @Published private(set) var list: TodoTaskList
    @Published private(set) var isLoading : Bool = false
    var uncompletedTasksCount: Int {
        list.unCompletedTasksCount
    }
    private let addTodoUseCase: AddTodoUseCaseType

    init(list: TodoTaskList, addTodoUseCase: AddTodoUseCaseType = AddTodoUseCase()) {
        self.list = list
        self.addTodoUseCase = addTodoUseCase
    }

    func save(todoTaskName: String) async throws {
        isLoading = true
        defer {
            isLoading = false
        }
        let newTodoTask = try await addTodoUseCase.create(todoTaskName: todoTaskName)
        list.add(newTodoTask)
    }

    func delete(_ todoTask: TodoTask) {
        list.delete(todoTask)
    }
    
    func toggleCompletion(_ todoTask: TodoTask) {
        list.toggleCompletion(todoTask)
    }
}
