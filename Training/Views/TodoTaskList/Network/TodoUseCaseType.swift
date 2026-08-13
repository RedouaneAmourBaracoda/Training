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
        guard let createdTodo = todosDTO.toTodoList.first(where: { $0.name == normalizedName }) else {
            throw TodoError.unknown
        }
        return createdTodo
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
            request.url?.appendPathComponent("\(id)")
        case let .update(id, todo):
            request.url?.appendPathComponent("\(id)")
            request.httpBody = try JSONEncoder().encode(todo)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
