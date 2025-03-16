//
//  HomeViewModel.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var books: [Doc] = []
    @Published var isLoading = false
    @Published var hasMoreData = true
    @Published var imageCache: [String: UIImage] = [:]
    @Published var bookmarkedBooks: Set<BookMarksModel> = []
    
    private var currentPage = 1
    
    func toggleBookmark(for book: BookMarksModel) {
        if let existingBook = bookmarkedBooks.first(where: { $0.key == book.key }) {
            bookmarkedBooks.remove(existingBook)
        } else {
            bookmarkedBooks.insert(book)
        }
        saveBookmarks()
    }
    
    func isBookmarked(_ book: BookMarksModel) -> Bool {
        return bookmarkedBooks.contains { $0.key == book.key }
    }
    
    func saveBookmarks() {
        UserDefaultsManager.shared.save(Array(bookmarkedBooks), forKey: "bookmarkedBooks")
    }
    
    func loadBookmarks() {
        if let decodedBookmarks: [BookMarksModel] = UserDefaultsManager.shared.load([BookMarksModel].self, forKey: "bookmarkedBooks") {
            bookmarkedBooks = Set(decodedBookmarks)
        } else {
            UserDefaultsManager.shared.remove(forKey: "bookmarkedBooks")
        }
    }
    
    func loadImage(for book: Doc) async {
        guard let coverId = book.coverI else { return }
        let urlString = "https://covers.openlibrary.org/b/id/\(coverId).jpg"
        
        guard let url = URL(string: urlString) else { return }
        
        if imageCache[book.key] != nil {
            return  // Image already cached
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageCache[book.key] = image
                }
            }
        } catch {
            print("Failed to load image for \(book.key): \(error.localizedDescription)")
        }
    }
    
    func fetchResults(searchQuery: String, reset: Bool = false, booksRepo: BooksSearchRepo = BooksSearchRepoImpl()) async {
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
            print("❌ Error fetching books:", error)
        }
        
        isLoading = false
    }
}
