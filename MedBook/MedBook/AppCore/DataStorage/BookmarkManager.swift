//
//  BookmarkManager.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 17/03/25.
//

import SwiftData
import Foundation

@Model
class BookMarksModel {
    @Attribute(.unique) var key: String
    var coverI: Int
    var author: String
    var title: String
    
    init(key: String, coverI: Int, author: String, title: String) {
        self.key = key
        self.coverI = coverI
        self.author = author
        self.title = title
    }
}

@MainActor
class BookmarkManager {
    static let shared = BookmarkManager()
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    private init() {
        do {
            modelContainer = try ModelContainer(for: BookMarksModel.self)
            modelContext = modelContainer.mainContext
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
        // Toggle Bookmark (Add/Remove)
    func toggleBookmark(for book: BookMarksModel) {
        if let existingBook = fetchBookmark(byKey: book.key) {
            modelContext.delete(existingBook) // Remove if exists
        } else {
            modelContext.insert(book) // Add new bookmark
        }
        
        do {
            try modelContext.save()
            print("Bookmark updated successfully!")
        } catch {
            print("Failed to update bookmark: \(error)")
        }
    }
    
        // Check if a book is bookmarked
    func isBookmarked(_ book: BookMarksModel) -> Bool {
        return fetchBookmark(byKey: book.key) != nil
    }
    
        // Fetch a specific bookmark by key
    func fetchBookmark(byKey key: String) -> BookMarksModel? {
        let fetchDescriptor = FetchDescriptor<BookMarksModel>(
            predicate: #Predicate { $0.key == key }
        )
        return try? modelContext.fetch(fetchDescriptor).first
    }
    
        // Fetch all bookmarks
    func fetchAllBookmarks() -> [BookMarksModel] {
        let fetchDescriptor = FetchDescriptor<BookMarksModel>()
        return (try? modelContext.fetch(fetchDescriptor)) ?? []
    }
    
    @MainActor
    func deleteBookmark(forKey key: String) {
        guard let bookToDelete = fetchBookmark(byKey: key) else {
            print("Bookmark not found for key: \(key)")
            return
        }
        
        modelContext.delete(bookToDelete) // Remove bookmark
        
        do {
            try modelContext.save()
            print("Bookmark deleted successfully!")
        } catch {
            print("Failed to delete bookmark: \(error)")
        }
    }

}
