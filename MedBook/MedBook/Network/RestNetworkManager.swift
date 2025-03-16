//
//  RestNetworkManager.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import Foundation

class RestNetworkManager {
    private init() {  }
    
    static let shared = RestNetworkManager()
    
    func perform<T:Codable>(request: URLRequest, for dataType: T.Type) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let responseCode = response as? HTTPURLResponse, (200...300).contains(responseCode.statusCode) else {
                throw NSError(domain: "request invalid", code: 400)
            }
            
            guard !data.isEmpty else {
                throw NSError(domain: "empty data", code: 500)
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(dataType, from: data)
            
        } catch {
            throw error
        }
    }
}
