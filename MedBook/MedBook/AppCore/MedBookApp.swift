//
//  MedBookApp.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import SwiftUI
import SwiftData

@main
struct MedBookApp: App {
    
    var sharedModelContainer: ModelContainer = {
        do {
            let schema = Schema([CountryList.self, UserCredentials.self, BookMarksModel.self])
            let modelConfiguration = ModelConfiguration(schema: schema,
                                                        isStoredInMemoryOnly: false)
            return try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            LandingScreen()
                .environmentObject(Router())
                .modelContainer(sharedModelContainer)
        }
    }
}
