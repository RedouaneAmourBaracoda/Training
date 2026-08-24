//
//  LoadTodoUseCaseType.swift
//  Training
//
//  Created by Redouane Amour on 09/08/2026.
//

import Foundation

protocol TodoUseCaseType {
    func load() async throws -> [TodoTask]
    func create(todoTaskName: String) async throws -> TodoTask
    func update(todoTask: TodoTask) async throws -> TodoTask
    func delete(todoTask: TodoTask) async throws -> TodoTask
}

struct TodoUseCase: TodoUseCaseType {
    private let todoAPIClient: APIClientType
    private let todoEndpointBuilder: TodoEndpointBuilder

    init(todoAPIClient: APIClientType = APIClient(), endpointBuilder: TodoEndpointBuilder = TodoEndpointBuilder()) {
        self.todoAPIClient = todoAPIClient
        self.todoEndpointBuilder = endpointBuilder
    }

    func load() async throws -> [TodoTask] {
        let request = try todoEndpointBuilder.makeRequest(action: .load)
        let todosDTO: [TodoResponseDTO] = try await todoAPIClient.send(request: request)
        return todosDTO.toTodoList
    }

    func create(todoTaskName: String) async throws -> TodoTask {
        let normalizedName = try normalize(todoTaskName)
        let request = try todoEndpointBuilder.makeRequest(action: .add(todo: TodoRequestDTO(name: normalizedName)))
        let todosDTO: [TodoResponseDTO] = try await todoAPIClient.send(request: request)
        guard todosDTO.count == 1, let createdTodo = todosDTO.toTodoList.first else { throw TodoError.unknown }
        return createdTodo
    }

    func update(todoTask: TodoTask) async throws -> TodoTask {
        let request = try todoEndpointBuilder.makeRequest(action: .update(id: todoTask.id, todo: .init(todoTask)))
        let todosDTO: [TodoResponseDTO] = try await todoAPIClient.send(request: request)
        guard todosDTO.count == 1, let updatedTodo = todosDTO.toTodoList.first else { throw TodoError.unknown }
        return updatedTodo
    }

    func delete(todoTask: TodoTask) async throws -> TodoTask {
        let request = try todoEndpointBuilder.makeRequest(action: .delete(id: todoTask.id))
        let todosDTO: [TodoResponseDTO] = try await todoAPIClient.send(request: request)
        guard todosDTO.count == 1, let deletedTodo = todosDTO.toTodoList.first else { throw TodoError.unknown }
        return deletedTodo
    }

    private func normalize(_ todoTaskName: String) throws -> String {
        let trimmedText = todoTaskName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            throw TodoError.emptyName
        }
        return trimmedText
    }
}

protocol AuthUseCaseType {
    func signup(email: String, password: String) async throws -> AuthResponseDTO
    func login(email: String, password: String) async throws -> AuthResponseDTO
}

struct AuthUseCase: AuthUseCaseType {
    private let authAPIClient: APIClientType
    private let authEndpointBuilder: AuthEndpointBuilder

    init(authAPIClient: APIClientType = APIClient(), endpointBuilder: AuthEndpointBuilder = AuthEndpointBuilder()) {
        self.authAPIClient = authAPIClient
        self.authEndpointBuilder = endpointBuilder
    }

    func signup(email: String, password: String) async throws -> AuthResponseDTO {
        let request = try authEndpointBuilder.makeRequest(action: .signup, authRequest: .init(email: email, password: password))
        return try await authAPIClient.send(request: request)
    }

    func login(email: String, password: String) async throws -> AuthResponseDTO {
        let request = try authEndpointBuilder.makeRequest(action: .login, authRequest: .init(email: email, password: password))
        return try await authAPIClient.send(request: request)
    }
}
