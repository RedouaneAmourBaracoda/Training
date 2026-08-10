//
//  EndPointBuilder.swift
//  Training
//
//  Created by Redouane Amour on 10/08/2026.
//

import Foundation

struct TodoEndpointBuilder {
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    enum TodoEndpoint {
        case load
        case add(todo: CreateTodoDTO)
        case delete(id: Int)
        case update(id: Int, todo: CreateTodoDTO)
        
        var httpMethod: String {
            switch self {
            case .load: "GET"
            case .add: "POST"
            case .delete: "DELETE"
            case .update: "PATCH"
            }
        }
    }

    func makeRequest(for endpoint: TodoEndpoint) throws -> URLRequest {
        var request = URLRequest(url: baseURL)
        request.httpMethod = endpoint.httpMethod
        switch endpoint {
        case .load:
            break
        case let .add(todo):
            request.httpBody = try JSONEncoder().encode(todo)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
