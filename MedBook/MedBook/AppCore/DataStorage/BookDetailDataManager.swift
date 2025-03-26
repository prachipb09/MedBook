//
//  BookDetailDataManager.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 26/03/25.
//

import SwiftData
import SwiftUI

@Model
class BookDetailResponse {
    var title: String
    var author: String
    var userEmail: String
    var date: String
    var bookDescription: String
    var key: String
    var coverI: Int
    
    init(title: String, author: String, userEmail: String, date: String, bookDescription: String, key: String, coverI: Int) {
        self.title = title
        self.author = author
        self.userEmail = userEmail
        self.date = date
        self.bookDescription = bookDescription
        self.key = key
        self.coverI = coverI
    }
}

@MainActor
class BookDetailDataManager {
    static let shared = BookDetailDataManager()
    private let modelContext = SharedModelContainer.shared.modelContext
    
    func fetchBook(byKey key: String, coverI: Int, userEmail: String) -> BookDetailResponse? {
        let fetchDescriptor = FetchDescriptor<BookDetailResponse>(
            predicate: #Predicate { $0.key == key && $0.coverI == coverI && $0.userEmail == userEmail }
        )
        return try? modelContext.fetch(fetchDescriptor).first
    }
    
    
    func saveBookDetail(for book: BookDetailResponse) throws  {
        modelContext.insert(book)
        do {
            try modelContext.save()
            print("User saved successfully!")
        } catch {
            print("Failed to save user: \(error)")
        }
    }
}
