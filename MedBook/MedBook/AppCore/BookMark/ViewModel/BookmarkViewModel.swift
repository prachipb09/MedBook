import Foundation

class BookmarkViewModel: ObservableObject {
    
    @Published var bookmarkedBooks: Set<BookMarksModel> = []
    let callback: (Set<BookMarksModel>) -> Void
    
    init(bookmarkedBooks: Set<BookMarksModel>, callback: @escaping (Set<BookMarksModel>) -> Void) {
        self.callback = callback
        self.bookmarkedBooks = bookmarkedBooks
        loadBookmarks()
    }
    
    func toggleBookmark(for book: BookMarksModel) {
        if bookmarkedBooks.contains(book) {
            bookmarkedBooks.remove(book)
        } else {
            bookmarkedBooks.insert(book)
        }
        saveBookmarks()
    }
    
    func removeBookmark(for book: BookMarksModel) {
        bookmarkedBooks.remove(book)
        saveBookmarks()
    }
    
    func isBookmarked(_ book: BookMarksModel) -> Bool {
        return bookmarkedBooks.contains(book)
    }
    
    private func saveBookmarks() {
        do {
            let data = try JSONEncoder().encode(Array(bookmarkedBooks))
            UserDefaults.standard.set(data, forKey: "bookmarkedBooks")
            callback(bookmarkedBooks)
        } catch {
            print("❌ Failed to save bookmarks: \(error)")
        }
    }
    
    func loadBookmarks() {
        guard let data = UserDefaults.standard.data(forKey: "bookmarkedBooks") else {
            print("ℹ️ No bookmarks found in UserDefaults")
            return
        }
        do {
            let bookmarks = try JSONDecoder().decode([BookMarksModel].self, from: data)
            bookmarkedBooks = Set(bookmarks)
        } catch {
            print("❌ Failed to load bookmarks: \(error.localizedDescription)")
        }
    }
}
