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
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(Response.self, from: data)
    }
}
