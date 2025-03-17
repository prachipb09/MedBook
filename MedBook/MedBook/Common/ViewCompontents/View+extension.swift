//
//  View+extension.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 16/03/25.
//

import SDWebImageSwiftUI
import SwiftUI

extension View {
    
    @ViewBuilder
    func bookCoverImage(for coverI: Int) -> some View {
        WebImage(url: URL(string: "https://covers.openlibrary.org/b/id/\(coverI)-M.jpg")) { image in
            image.resizable()
                .frame(width: 70, height: 70, alignment: .center)
        } placeholder: {
            Image(systemName: "book.closed") // Use an SF Symbol
                .resizable()
                .frame(width: 70, height: 70, alignment: .center)
                .foregroundColor(.gray)
                .opacity(0.5)
        }
        .transition(.fade(duration: 0.5)) // Fade Transition with duration
        .scaledToFit()
        .cornerRadius(10)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
