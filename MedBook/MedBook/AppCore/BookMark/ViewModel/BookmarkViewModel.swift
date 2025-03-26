import Foundation

@MainActor
class BookmarkViewModel: ObservableObject {
    
    @Published var bookmarkedBooks: [BookMarksModel]
    
    private var mailID: String {
        KeychainHelper.shared.get(LoginUserData.self, forKey: "isUserLoggedIn")?.emailID ?? ""
    }
    
    init(bookmarkedBooks: [BookMarksModel] = []) {
        self.bookmarkedBooks = bookmarkedBooks
        loadBookmarks()
    }
    
    func removeBookmark(for book: BookMarksModel) {
        BookmarkManager.shared.deleteBookmark(forKey: book.key, coverI: book.coverI, userEmail: mailID)
        loadBookmarks()
        NotificationCenter.default.post(name: .bookMarkChanged, object: nil)

    }
    
    func loadBookmarks() {
        bookmarkedBooks = BookmarkManager.shared.fetchAllBookmarks(for: mailID)
    }
}
