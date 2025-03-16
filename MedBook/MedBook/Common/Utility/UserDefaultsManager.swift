//
//  UserDefaultsManager.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 16/03/25.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    func save<T: Codable>(_ value: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            defaults.set(data, forKey: key)
        } catch {
            print("❌ Failed to save \(key): \(error)")
        }
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else {
            print("ℹ️ No data found for key: \(key)")
            return nil
        }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("❌ Failed to load \(key): \(error.localizedDescription)")
            return nil
        }
    }
    
    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
        print("🗑 Removed data for key: \(key)")
    }
}
