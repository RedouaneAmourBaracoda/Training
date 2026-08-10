//
//  AddTodoUseCase.swift
//  Training
//
//  Created by Redouane Amour on 04/08/2026.
//

import Foundation

protocol AddTodoUseCaseType {
    func create(todoTaskName: String) async throws -> TodoTask
}

struct AddTodoUseCase: AddTodoUseCaseType {
    func create(todoTaskName: String) async throws -> TodoTask {
        let normalizedName = try normalize(todoTaskName)
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return .init(id: UUID().hashValue, name: normalizedName)
    }

    private func normalize(_ todoTaskName: String) throws -> String {
        let trimmedText = todoTaskName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            throw AddTodoError.empty
        }
        return trimmedText
    }
}

enum AddTodoError: Error {
    case empty
    case unknown
    
    var userMessage: String {
        switch self {
        case .empty: "A task cannot be empty."
        case .unknown: "An unknown error with the server occured. Please try again later."
        }
    }
}
