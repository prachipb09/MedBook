//
//  CountriesRepo.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import Foundation

protocol CountriesRepo {
    func fetchCountries(restRepository: CountriesRestRepo) async throws -> Countries
}

class CountriesRepoImpl: CountriesRepo {
    func fetchCountries(restRepository: CountriesRestRepo) async throws -> Countries {
        let urlRequest = try await restRepository.getUrlRequest()
        return try await RestNetworkManager.shared.perform(request: urlRequest, for: Countries.self)
    }
}

enum CountriesRestRepo: NetworkRepository {
    case countriesList
    
    var host: String {
        switch self {
            case .countriesList: return "api.first.org"
        }
    }
    
    var path: String {
        switch self {
            case .countriesList: return "/data/v1/countries" // ✅ Added `/`
        }
    }
    
    var httpMethod: String {
        switch self {
            case .countriesList: return "GET"
        }
    }
    
    var scheme: String {
        switch self {
            case .countriesList: return "https"
        }
    }
}
