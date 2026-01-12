//
//  NetworkError.swift
//  TelepartyDemoApp
//
//  Created by Sandeep S on 12/01/26.
//


import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case underlying(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case .httpError(let code):
            return "Server error (HTTP \(code))"
        case .decodingError:
            return "Failed to decode response"
        case .underlying(let error):
            return error.localizedDescription
        }
    }
}
