//
//  String+extensions.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 16/03/25.
//

import Foundation

extension String {
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return predicate.evaluate(with: self)
    }
    
    var trim: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
