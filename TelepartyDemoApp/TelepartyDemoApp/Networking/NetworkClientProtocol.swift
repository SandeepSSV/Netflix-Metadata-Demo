//
//  NetworkClientProtocol.swift
//  TelepartyDemoApp
//
//  Created by Sandeep S on 12/01/26.
//


import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(_ request: URLRequest) async throws -> T
}

final class NetworkClient: NetworkClientProtocol {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.httpError(httpResponse.statusCode)
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }

        } catch {
            throw NetworkError.underlying(error)
        }
    }
}
