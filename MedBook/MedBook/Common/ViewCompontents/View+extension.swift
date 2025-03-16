//
//  View+extension.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 16/03/25.
//


import SwiftUI
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
