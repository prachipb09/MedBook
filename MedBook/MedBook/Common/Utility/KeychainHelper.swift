//
//  KeychainHelper.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//


import Security
import Foundation

class KeychainHelper {
    
    static let shared = KeychainHelper()
    
    private init() {}
    
    // MARK: - Save Object to Keychain
    func save<T: Codable>(_ object: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            
            // Delete existing entry before saving new one
            SecItemDelete(query as CFDictionary)
            
            let status = SecItemAdd(query as CFDictionary, nil)
            if status == errSecSuccess {
                print("✅ Object saved successfully.")
            } else {
                print("❌ Failed to save object: \(status)")
            }
        } catch {
            print("❌ Encoding error: \(error)")
        }
    }
    
    // MARK: - Retrieve Object from Keychain
    func get<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var retrievedData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &retrievedData)
        
        if status == errSecSuccess, let data = retrievedData as? Data {
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                print("❌ Decoding error: \(error)")
            }
        } else {
            print("❌ Failed to retrieve object: \(status)")
        }
        
        return nil
    }
    
    // MARK: - Delete Object from Keychain
    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("✅ Object deleted successfully.")
        } else {
            print("❌ Failed to delete object: \(status)")
        }
    }
}
