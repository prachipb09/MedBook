import Foundation

@MainActor
class BookmarkViewModel: ObservableObject {
    
    @Published var bookmarkedBooks: [BookMarksModel] = []
    let callback: (Bool) -> Void
    
    init(bookmarkedBooks: [BookMarksModel], callback: @escaping (Bool) -> Void) {
        self.callback = callback
        self.bookmarkedBooks = bookmarkedBooks
        loadBookmarks()
    }
    
    func removeBookmark(for book: BookMarksModel) {
        BookmarkManager.shared.deleteBookmark(forKey: book.key)
        loadBookmarks()
        callback(true)
    }
    
    func loadBookmarks() {
        bookmarkedBooks = BookmarkManager.shared.fetchAllBookmarks()
    }
}
