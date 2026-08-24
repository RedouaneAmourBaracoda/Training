//
//  EndpointBuilder.swift
//  Training
//
//  Created by Redouane Amour on 17/08/2026.
//

import Foundation

struct APIConfiguration {
    let url: URL
    let publishableKey: String
    
    static let todoAPIConfiguration: APIConfiguration = .init(
        url: URL(string: "https://yjictxhqmuklxifmctgi.supabase.co/rest/v1/todos")!,
        publishableKey: "sb_publishable_vgkCWo7arXRfzis11Db12Q_E1UlVO3Z"
    )
    static let authAPIConfiguration: APIConfiguration = .init(
        url: URL(string: "https://yjictxhqmuklxifmctgi.supabase.co/auth/v1")!,
        publishableKey: "sb_publishable_vgkCWo7arXRfzis11Db12Q_E1UlVO3Z"
    )
}

struct TodoEndpointBuilder {
    private let todoAPIConfiguration: APIConfiguration

    init(todoAPIConfiguration: APIConfiguration = .todoAPIConfiguration) {
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

struct AuthEndpointBuilder {
    private let authAPIConfiguration: APIConfiguration

    init(apiConfiguration: APIConfiguration = .authAPIConfiguration) {
        self.authAPIConfiguration = apiConfiguration
    }

    enum AuthAction {
        case signup
        case login

        var resourcePath: String {
            switch self {
            case .signup: return "signup"
            case .login: return "token"
            }
        }
    }

    func makeRequest(action: AuthAction, authRequest: AuthRequestDTO) throws -> URLRequest {
        let url = authAPIConfiguration.url.appendingPathComponent(action.resourcePath)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(authAPIConfiguration.publishableKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(authRequest)
        var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!
        switch action {
        case .login:
            components.queryItems = [URLQueryItem(name: "grant_type", value: "password")]
        case .signup : break
        }
        request.url = components.url!
        return request
    }
}

struct AuthSession {
    let userId: String
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date
}

actor SessionStore {
    private var session: AuthSession?

    func currentSession() -> AuthSession? {
        session
    }
    
    func setSession(_ session: AuthSession) {
        self.session = session
    }
}
