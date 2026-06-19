//
// HTTPClient.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/18/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
	
import Foundation

/// A lightweight HTTP client that builds a URLRequest from an APIRequest.
struct HTTPClient {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        baseURL: URL = URL(string: "https://api.example.com")!,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }

    func send<T: Decodable>(_ apiRequest: APIRequest) async throws -> T {
        let urlRequest = try buildURLRequest(from: apiRequest)
        let (data, response) = try await session.data(for: urlRequest)

        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try decoder.decode(T.self, from: data)
    }

    // MARK: - Private

    private func buildURLRequest(from apiRequest: APIRequest) throws -> URLRequest {
        var url = baseURL.appendingPathComponent(apiRequest.path)

        // Append query parameters for GET requests
        if apiRequest.method == .get, let params = apiRequest.parameters {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
            url = components.url!
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiRequest.method.rawValue

        // Default headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        // Custom headers (e.g. Authorization)
        apiRequest.headers?.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        // JSON-encode body parameters for non-GET requests
        if apiRequest.method != .get, let params = apiRequest.parameters {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }

        return urlRequest
    }
}
