//
//  File.swift
//  Training
//
//  Created by Redouane Amour on 15/07/2026.
//

import Combine
import Foundation

enum AddTodoState {
    case idle
    case isLoading
}

final class TodoTaskListViewModel: ObservableObject {
    @Published var list: TodoTaskList
    @Published var addTodoState: AddTodoState = .idle
    var uncompletedTasksCount: Int {
        list.unCompletedTasksCount
    }
    var isLoading : Bool {
        switch addTodoState {
        case .isLoading: return true
        default : return false
        }
    }
    private let addTodoUseCase: AddTodoUseCaseType

    init(list: TodoTaskList, addTodoUseCase: AddTodoUseCaseType = AddTodoUseCase()) {
        self.list = list
        self.addTodoUseCase = addTodoUseCase
    }

    func save(todoTaskName: String) async -> Result<Void, Error> {
        addTodoState = .isLoading
        defer {
            addTodoState = .idle
        }
        do {
            let newTodoTask = try await addTodoUseCase.create(todoTaskName: todoTaskName)
            list.add(newTodoTask)
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    func delete(_ todoTask: TodoTask) {
        list.delete(todoTask)
    }
    
    func toggleCompletion(_ todoTask: TodoTask) {
        list.toggleCompletion(todoTask)
    }
}
