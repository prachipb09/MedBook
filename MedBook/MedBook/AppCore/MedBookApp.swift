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
    
    var body: some Scene {
        WindowGroup {
            LandingScreen()
                .environmentObject(Router())
                .modelContainer(SharedModelContainer.shared.modelContainer)
        }
    }
}
