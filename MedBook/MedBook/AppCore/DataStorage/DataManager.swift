//
//  DataManager.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 18/03/25.
//

import SwiftData
import Foundation

@MainActor
class SharedModelContainer {
    static let shared = SharedModelContainer()
    let modelContext: ModelContext
    let modelContainer: ModelContainer
    
    private init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
        do {
            let schema = Schema([UserCredentials.self, BookMarksModel.self, CountryList.self, BookDetailResponse.self])  // ✅ All Models
            let configuration = ModelConfiguration()
            self.modelContainer = try ModelContainer(for: schema, configurations: [configuration])
            self.modelContext = modelContainer.mainContext
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }
}
