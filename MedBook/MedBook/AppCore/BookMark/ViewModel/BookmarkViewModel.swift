import Foundation

class BookmarkViewModel: ObservableObject {
    
    @Published var bookmarkedBooks: Set<BookMarksModel> = []
    let callback: (Set<BookMarksModel>) -> Void
    
    init(bookmarkedBooks: Set<BookMarksModel>, callback: @escaping (Set<BookMarksModel>) -> Void) {
        self.callback = callback
        self.bookmarkedBooks = bookmarkedBooks
        loadBookmarks()
    }
    
    func removeBookmark(for book: BookMarksModel) {
        bookmarkedBooks.remove(book)
        saveBookmarks()
    }
    
    private func saveBookmarks() {
        UserDefaultsManager.shared.save(Array(bookmarkedBooks), forKey: "bookmarkedBooks")
        callback(bookmarkedBooks)
    }
    
    func loadBookmarks() {
        if let bookmarks: [BookMarksModel] = UserDefaultsManager.shared.load([BookMarksModel].self, forKey: "bookmarkedBooks") {
            bookmarkedBooks = Set(bookmarks)
        }
    }
}
