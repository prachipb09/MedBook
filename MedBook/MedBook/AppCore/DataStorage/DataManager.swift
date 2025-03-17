//
//  DataManager.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 18/03/25.
//

import SwiftData

@MainActor
class SharedModelContainer {
    static let shared = SharedModelContainer()
    let modelContext: ModelContext
    let modelContainer: ModelContainer
    
    private init() {
        do {
            let schema = Schema([UserCredentials.self, BookMarksModel.self, CountryList.self])  // ✅ All Models
            let configuration = ModelConfiguration()
            self.modelContainer = try ModelContainer(for: schema, configurations: [configuration])
            self.modelContext = modelContainer.mainContext
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }
}
