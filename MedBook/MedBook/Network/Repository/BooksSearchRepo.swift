//
//  BooksSearchRepo.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import Foundation

protocol BooksSearchRepo {
    func fetchBooks(restRepository: BooksSearchRestRepo) async throws -> Books
}

class BooksSearchRepoImpl: BooksSearchRepo {
    func fetchBooks(restRepository: BooksSearchRestRepo) async throws -> Books {
        let urlRequest = try await restRepository.getUrlRequest()
        return try await RestNetworkManager.shared.perform(request: urlRequest, for: Books.self)
    }
}

enum BooksSearchRestRepo: NetworkRepository {
    case book(searchItem: String, page: Int = 1, limit: Int = 10) // Added page & limit
    
    var host: String { "openlibrary.org" }
    
    var path: String { "/search.json" }
    
    var httpMethod: String { "GET" }
    
    var scheme: String { "https" }
    
    var queryItems: [URLQueryItem]? {
        switch self {
            case .book(let searchItem, let page, let limit):
                return [
                    URLQueryItem(name: "title", value: searchItem),
                    URLQueryItem(name: "page", value: "\(page)"),  // 🆕 Page number
                    URLQueryItem(name: "limit", value: "\(limit)") // 🆕 Results per page
                ]
        }
    }
}
