//
//  NetworkRepository.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import Foundation

protocol DataRepository { }

protocol NetworkRepository: DataRepository {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var httpMethod: String { get }
    var queryItems: [URLQueryItem]? { get }
    var payload: Data? { get }
    var extraHeaders: [String: String]? { get }
}

extension NetworkRepository {
   
    var queryItems: [URLQueryItem]? { return nil }
    
    var payload: Data? { return nil }
    
    var extraHeaders: [String: String]? { return nil }
    
    var requireCatToken: Bool { return true }
    
    var defaultHeaders: [String: String?] {
        return [:]
    }
    
  func getUrlRequest() async throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        urlRequest.httpMethod = httpMethod
        urlRequest.httpBody = payload
        urlRequest.timeoutInterval = 30
        
        var allHeaders = defaultHeaders.compactMapValues { $0 }
        if let extraHeaders = extraHeaders {
            allHeaders.merge(extraHeaders) { _, new in new }
        }
        urlRequest.allHTTPHeaderFields = allHeaders
        
        return urlRequest
    }
}

