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
            return try ModelContainer(for: CountryList.self, UserCredentials.self, BookMarksModel.self)
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
