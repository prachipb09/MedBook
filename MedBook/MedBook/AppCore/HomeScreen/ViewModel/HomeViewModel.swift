//
//  HomeViewModel.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var books: [Doc] = []
    @Published var isLoading = false
    @Published var hasMoreData = true
    @Published var bookmarkedBooks: [BookMarksModel] = []
    
    private var currentPage = 1
    
    var mailID: String {
        KeychainHelper.shared.get(LoginUserData.self, forKey: "isUserLoggedIn")?.emailID ?? ""
    }
    
    func toggleBookmark(for book: BookMarksModel) {
        BookmarkManager.shared.toggleBookmark(for: book, userEmail: mailID)
    }
    
    func isBookmarked(_ book: BookMarksModel) -> Bool {
        BookmarkManager.shared.isBookmarked(book, userEmail: mailID)
    }
    
    func loadBookmarks() {
        bookmarkedBooks = BookmarkManager.shared.fetchAllBookmarks(for: mailID)
    }
    
    func fetchResults(searchQuery: String, reset: Bool = false, booksRepo: BooksSearchRepo = BooksSearchRepoImpl()) async throws {
        if reset {
            books.removeAll() // Reset the books list for new search
            currentPage = 1
            hasMoreData = true
            isLoading = false
        }
        
        guard !isLoading, hasMoreData else { return } // Prevent duplicate calls
        isLoading = true
        
        do {
            let result = try await booksRepo.fetchBooks(restRepository: .book(searchItem: searchQuery, page: currentPage, limit: 10))
            
            if result.docs.isEmpty {
                hasMoreData = false // No more data available
            } else {
                books.append(contentsOf: result.docs)
                currentPage += 1 // Move to next page
            }
        } catch {
            throw error
        }
        isLoading = false
    }
}
