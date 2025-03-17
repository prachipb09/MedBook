import Foundation

@MainActor
class BookmarkViewModel: ObservableObject {
    
    @Published var bookmarkedBooks: [BookMarksModel] = []
    let callback: (Bool) -> Void
    private var mailID: String {
        KeychainHelper.shared.get(LoginUserData.self, forKey: "isUserLoggedIn")?.emailID ?? ""
    }
    init(bookmarkedBooks: [BookMarksModel], callback: @escaping (Bool) -> Void) {
        self.callback = callback
        self.bookmarkedBooks = bookmarkedBooks
        loadBookmarks()
    }
    
    func removeBookmark(for book: BookMarksModel) {
        BookmarkManager.shared.deleteBookmark(forKey: book.key, coverI: book.coverI, userEmail: mailID)
        loadBookmarks()
        callback(true)
    }
    
    func loadBookmarks() {
        bookmarkedBooks = BookmarkManager.shared.fetchAllBookmarks(for: mailID)
    }
}
