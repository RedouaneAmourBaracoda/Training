//
//  LoadTodoUseCaseType.swift
//  Training
//
//  Created by Redouane Amour on 09/08/2026.
//

import Foundation

protocol LoadTodoUseCaseType {
    func load() async throws -> [TodoTask]
}

struct LoadTodoUseCase: LoadTodoUseCaseType {
    private let apiClient: APIClientType
    private let todoEndpointBuilder: TodoEndpointBuilder

    init(apiClient: APIClientType = APIClient(), todoEndpointBuilder: TodoEndpointBuilder = TodoEndpointBuilder()) {
        self.apiClient = apiClient
        self.todoEndpointBuilder = todoEndpointBuilder
    }

    func load() async throws -> [TodoTask] {
        let request = try todoEndpointBuilder.makeRequest(for: .load)
        let todosDTO: [TodoResponseDTO] = try await apiClient.send(request: request)
        return todosDTO.toTodoTasks
    }
}
