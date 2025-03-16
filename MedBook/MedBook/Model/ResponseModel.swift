
import SwiftUI
    // MARK: - Books
struct Books: Codable {
    let numFound, start: Int
    let numFoundExact: Bool
    let documentationUrl: String
    let q: String
    let offset: String?
    let docs: [Doc]
}
    // MARK: - Doc
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

struct BookMarksModel: Codable, Hashable {
    let key: String
    let imageData: Data? // Store image as Data
    let author: String
    let title: String
    
    var uiImage: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    static func == (lhs: BookMarksModel, rhs: BookMarksModel) -> Bool {
        return lhs.key == rhs.key
    }
}

struct UserCredentials: Codable {
    let email: String
    let password: String
    let country: String
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
