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
        let request = try todoEndpointBuilder.makeRequest(action: .add(todo: .init(name: normalizedName)))
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

struct TodoAPIConfiguration {
    let url: URL = URL(string: "https://yjictxhqmuklxifmctgi.supabase.co/rest/v1/todos")!
    let publishableKey: String = "sb_publishable_vgkCWo7arXRfzis11Db12Q_E1UlVO3Z"
}

struct TodoEndpointBuilder {
    private let todoAPIConfiguration: TodoAPIConfiguration
    
    init(todoAPIConfiguration: TodoAPIConfiguration = .init()) {
        self.todoAPIConfiguration = todoAPIConfiguration
    }

    enum TodoAction {
        case load
        case add(todo: TodoRequestDTO)
        case delete(id: Int)
        case update(id: Int, todo: TodoRequestDTO)
        
        var httpMethod: String {
            switch self {
            case .load: "GET"
            case .add: "POST"
            case .delete: "DELETE"
            case .update: "PATCH"
            }
        }
    }

    func makeRequest(action: TodoAction) throws -> URLRequest {
        var request = URLRequest(url: todoAPIConfiguration.url)
        request.setValue(todoAPIConfiguration.publishableKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = action.httpMethod
        switch action {
        case .load:
            break
        case let .add(todo):
            request.httpBody = try JSONEncoder().encode(todo)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("return=representation", forHTTPHeaderField: "Prefer")
        case let .delete(id):
            guard let url = request.url else { throw TodoError.unknown }
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            components.queryItems = [URLQueryItem(name: "id", value: "eq.\(id)")]
            request.url = components.url!
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("return=representation", forHTTPHeaderField: "Prefer")
        case let .update(id, todo):
            guard let url = request.url else { throw TodoError.unknown }
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            components.queryItems = [URLQueryItem(name: "id", value: "eq.\(id)")]
            request.url = components.url!
            request.httpBody = try JSONEncoder().encode(todo)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("return=representation", forHTTPHeaderField: "Prefer")
        }
        return request
    }
}

enum TodoError: Error {
    case emptyName
    case encoding
    case unknown
    
    var userMessage: String {
        switch self {
        case .emptyName: "A task cannot be empty."
        case .unknown: "An unknown error with the server occured. Please try again later."
        case .encoding: "DTO couldn't be encoded in JSON. Please try again later."
        }
    }
}
