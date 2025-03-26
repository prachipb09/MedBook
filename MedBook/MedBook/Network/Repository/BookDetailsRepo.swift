//
//  BookDetailsRepo.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 26/03/25.
//

import SwiftUI

protocol BookDetailsRepo {
    func getBookDetail(restRepository: BookDetailRestRepo) async throws -> BookDetailModel
}

class BookDetailRepoImpl: BookDetailsRepo {
    func getBookDetail(restRepository: BookDetailRestRepo) async throws -> BookDetailModel {
        do {
            let urlRequest = try await restRepository.getUrlRequest()
            return try await RestNetworkManager.shared.perform(request: urlRequest, for: BookDetailModel.self)
        } catch {
            throw error
        }
    }
}


enum BookDetailRestRepo: NetworkRepository {
    case bookDetail(String)
}
extension BookDetailRestRepo {
    var host: String { "openlibrary.org" }
    
    var path: String {
        switch self {
            case .bookDetail(let key):
                return "\(key).json"
        }
    }
    
    var httpMethod: String { "GET" }
    
    var scheme: String { "https" }
}

