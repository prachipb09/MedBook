
import SwiftUI

struct Books: Codable {
    let numFound, start: Int
    let numFoundExact: Bool
    let documentationUrl: String
    let q: String
    let offset: String?
    let docs: [Doc]
}

struct Doc: Codable, Hashable, Identifiable {
    let id = UUID()
    let authorKey, authorName: [String]?
    let coverEditionKey: String?
    let coverI: Int?
    let editionCount: Int
    let firstPublishYear: Int?
    let hasFulltext: Bool
    let ia: [String]?
    let iaCollectionS: String?
    let key: String
    let language: [String]?
    let lendingEditionS, lendingIdentifierS: String?
    let publicScanB: Bool
    let title: String
    let subtitle: String?
}

    // MARK: - Countries
struct Countries: Codable {
    let status: String
    let statusCode: Int
    let version, access: String
    let total, offset, limit: Int
    let data: [String: Datum]
    
    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status-code"
        case version, access, total, offset, limit, data
    }
}
    // MARK: - Datum
struct Datum: Codable {
    let country: String
    let region: Region
}

enum Region: String, Codable {
    case africa = "Africa"
    case antarctic = "Antarctic"
    case asia = "Asia"
    case centralAmerica = "Central America"
}

struct LoginUserData: Codable {
    let emailID: String
    let isLogged: Bool
}

struct BookDetailModel: Codable {
    let description: BookDescription?
    let title: String?
    let covers: [Int]?
    let subjects: [String]?
    let firstPublishDate: String?
    let subjectPeople: [String]?
    let key: String?
    let authors: [Author]?
    let excerpts: [Excerpt]?
    let type: CoverEdition?
    let subjectTimes: [String]?
    let coverEdition: CoverEdition?
    let latestRevision, revision: Int?
    let created, lastModified: Created?
}

struct BookDescription: Codable {
    let type: String?
    let value: String?
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.singleValueContainer()
        
            // Try decoding as a dictionary
        if let decodedObject = try? container?.decode(DescriptionObject.self) {
            self.type = decodedObject.type
            self.value = decodedObject.value
            return
        }
        
            // Try decoding as a simple string
        if let text = try? container?.decode(String.self) {
            self.type = nil
            self.value = text
            return
        }
        
            // If neither works, set as nil
        self.type = nil
        self.value = nil
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let type = type, let value = value {
            try container.encode(DescriptionObject(type: type, value: value))
        } else if let value = value {
            try container.encode(value)
        }
    }
}

struct DescriptionObject: Codable {
    let type: String?
    let value: String?
}

struct Author: Codable {
    let author, type: CoverEdition?
}

struct CoverEdition: Codable {
    let key: String?
}

struct Created: Codable {
    let type: String?
    let value: String?
}

struct Excerpt: Codable {
    let pages: String?
    let excerpt: String?
    let author: CoverEdition?
    let comment: String?
}

struct Link: Codable {
    let title: String?
    let url: String?
    let type: CoverEdition?
}
