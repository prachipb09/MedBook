import SwiftData
import Foundation

@Model
class BookMarksModel {
    var key: String
    var coverI: Int
    var author: String
    var title: String
    var userEmail: String
    
    @Attribute(.unique) var uniqueID: String { "\(key)_\(coverI)_\(userEmail)" } 
    
    init(key: String, coverI: Int, author: String, title: String, userEmail: String) {
        self.key = key
        self.coverI = coverI
        self.author = author
        self.title = title
        self.userEmail = userEmail
    }
}

@MainActor
class BookmarkManager {
    static let shared = BookmarkManager()
    private let modelContext = SharedModelContainer.shared.modelContext // ✅ Use shared context
    
        // Toggle Bookmark (Add/Remove) for a user
    func toggleBookmark(for book: BookMarksModel, userEmail: String) {
        if let existingBook = fetchBookmark(byKey: book.key, coverI: book.coverI, userEmail: userEmail) {
            modelContext.delete(existingBook) // Remove if exists
        } else {
            let newBookmark = BookMarksModel(
                key: book.key,
                coverI: book.coverI,
                author: book.author,
                title: book.title,
                userEmail: userEmail
            )
            modelContext.insert(newBookmark) // Add new bookmark
        }
        
        do {
            try modelContext.save()
            print("Bookmark updated successfully!")
        } catch {
            print("Failed to update bookmark: \(error)")
        }
    }
    
        // Check if a book is bookmarked for a user
    func isBookmarked(_ book: BookMarksModel, userEmail: String) -> Bool {
        return fetchBookmark(byKey: book.key, coverI: book.coverI, userEmail: userEmail) != nil
    }
    
        // Fetch a specific bookmark by key and coverI for a user
    func fetchBookmark(byKey key: String, coverI: Int, userEmail: String) -> BookMarksModel? {
        let fetchDescriptor = FetchDescriptor<BookMarksModel>(
            predicate: #Predicate { $0.key == key && $0.coverI == coverI && $0.userEmail == userEmail }
        )
        return try? modelContext.fetch(fetchDescriptor).first
    }
    
        // Fetch all bookmarks for a specific user
    func fetchAllBookmarks(for userEmail: String) -> [BookMarksModel] {
        let fetchDescriptor = FetchDescriptor<BookMarksModel>(
            predicate: #Predicate { $0.userEmail == userEmail }
        )
        return (try? modelContext.fetch(fetchDescriptor)) ?? []
    }
    
        // Delete a bookmark for a specific user
    func deleteBookmark(forKey key: String, coverI: Int, userEmail: String) {
        guard let bookToDelete = fetchBookmark(byKey: key, coverI: coverI, userEmail: userEmail) else {
            print("Bookmark not found for key: \(key), coverI: \(coverI), and user: \(userEmail)")
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
