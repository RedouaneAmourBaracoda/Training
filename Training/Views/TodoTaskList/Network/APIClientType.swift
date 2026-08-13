//
//  APIClientType.swift
//  Training
//
//  Created by Redouane Amour on 07/08/2026.
//

import Foundation

protocol APIClientType {
    func send<Response: Decodable>(request: URLRequest) async throws -> Response
}

struct APIClient: APIClientType {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func send<Response: Decodable>(request: URLRequest) async throws -> Response {
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        switch httpResponse.statusCode {
        case 200..<300: return try JSONDecoder().decode(Response.self, from: data)
        default: throw APIError.http(statusCode: httpResponse.statusCode , response: try? JSONDecoder().decode(APIErrorResponse.self, from: data))
        }
    }
}

enum APIError: Error {
    case invalidResponse
    case http(
        statusCode: Int,
        response: APIErrorResponse?
    )
}

struct APIErrorResponse: Decodable {
    let code: String
    let message: String
    let details: String?
    let hint: String?
}
