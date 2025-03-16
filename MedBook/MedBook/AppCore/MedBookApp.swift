//
//  MedBookApp.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import SwiftUI

@main
struct MedBookApp: App {
    var body: some Scene {
        WindowGroup {
            LandingScreen()
                .environmentObject(Router())
        }
    }
}
