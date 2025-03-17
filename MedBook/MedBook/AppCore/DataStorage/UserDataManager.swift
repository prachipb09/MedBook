//
//  UserDataManager.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 17/03/25.
//

import SwiftData
import Foundation

@Model
class UserCredentials {
    var email: String
    var password: String
    var country: String
    
    init(email: String, password: String, country: String) {
        self.email = email
        self.password = password
        self.country = country
    }
}

@MainActor
class UserDataManager {
    static let shared = UserDataManager()
    let modelContext: ModelContext // ✅ Shared Context
    
    private init() {
            self.modelContext = SharedModelContainer.shared.modelContext
    }
    
        // ✅ Save a new user
    func saveUser(email: String, password: String, country: String) {
        if fetchUserByEmail(email: email) != nil {
            print("User with this email already exists.")
            return
        }
        
        let newUser = UserCredentials(email: email, password: password, country: country)
        modelContext.insert(newUser)
        
        do {
            try modelContext.save()
            print("User saved successfully!")
        } catch {
            print("Failed to save user: \(error)")
        }
    }
    
        // ✅ Fetch a user by email
    func fetchUserByEmail(email: String) -> UserCredentials? {
        let fetchDescriptor = FetchDescriptor<UserCredentials>(
            predicate: #Predicate { $0.email == email }
        )
        return try? modelContext.fetch(fetchDescriptor).first
    }
    
        // ✅ Fetch all users
    func fetchAllUsers() -> [UserCredentials] {
        let fetchDescriptor = FetchDescriptor<UserCredentials>()
        return (try? modelContext.fetch(fetchDescriptor)) ?? []
    }
    
        // ✅ Update user details
    func updateUser(email: String, newPassword: String?, newCountry: String?) {
        if let user = fetchUserByEmail(email: email) {
            if let newPassword = newPassword {
                user.password = newPassword
            }
            if let newCountry = newCountry {
                user.country = newCountry
            }
            do {
                try modelContext.save()
                print("User updated successfully!")
            } catch {
                print("Failed to update user: \(error)")
            }
        } else {
            print("User not found.")
        }
    }
    
        // ✅ Delete a user by email
    func deleteUser(email: String) {
        if let user = fetchUserByEmail(email: email) {
            modelContext.delete(user)
            do {
                try modelContext.save()
                print("User deleted successfully!")
            } catch {
                print("Failed to delete user: \(error)")
            }
        } else {
            print("User not found.")
        }
    }
}

