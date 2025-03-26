    //
    //  HomeScreen.swift
    //  MedBook
    //
    //  Created by Prachi Bharadwaj on 15/03/25.
    //

import SwiftUI

enum SortOption {
    case title
    case firstPublishYear
    case authorName
}

struct HomeScreen: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel = HomeViewModel()
    @State private var selectedSort: SortOption = .title
    @State private var searchText: String = ""
    @State private var debounceTask: Task<Void, Never>?

    var sortedBooks: [Doc] {
        switch selectedSort {
            case .title:
                return viewModel.books.sorted { ($0.title) < ($1.title) }
            case .firstPublishYear:
                return viewModel.books.sorted { ($0.firstPublishYear ?? Int.max) < ($1.firstPublishYear ?? Int.max) }
            case .authorName:
                return viewModel.books.sorted { ($0.authorName?.first ?? "") < ($1.authorName?.first ?? "") }
        }
    }
    
    var body: some View {
        NavigationBar(hideBackButton: true) {
            VStack(alignment: .leading, spacing: 16) {
                headerView()
                VStack {
                    searchBarView()
                    sortingOptionView()
                }
                .padding()
                .onChange(of: $searchText.wrappedValue) { oldValue, newValue in
                    performSearch(oldValue: oldValue, newValue: newValue)
                }
                
                if viewModel.books.isEmpty && !searchText.isEmpty {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    Spacer()
                } else {
                    listView()
                }
            }
            .padding()
        }.onTapGesture {
            self.hideKeyboard()
        }
        .onReceive(NotificationCenter.default.publisher(for: .bookMarkChanged), perform: { _ in
            Task {
                viewModel.loadBookmarks()
            }
        })
    }
    
    func searchBarView() -> some View {
        TextField("Search your books....", text: $searchText)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .overlay(
                Capsule()
                    .stroke(.black, lineWidth: 2.0)
            )
            .shadow(color: .black, radius: 10, x: 5, y: 5)
    }
    func performSearch(oldValue: String, newValue: String) {
        debounceTask?.cancel()
        
        let trimmedSearchText = newValue.trim
        
            // Ensure at least 3 characters before triggering API
        guard trimmedSearchText.count >= 3, oldValue != trimmedSearchText else {
            viewModel.books = []
            return
        }
            // Start a new debounce task
        debounceTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec delay
            
                // Ensure task wasn't cancelled before executing
            guard !Task.isCancelled else { return }
            
            try? await viewModel.fetchResults(searchQuery: trimmedSearchText, reset: true)
        }
    }
    
    func swipeActionView(bookmarkModel: BookMarksModel) -> some View {
        Button {
            viewModel.toggleBookmark(for: bookmarkModel)
        } label: {
            Label(
                viewModel.isBookmarked(bookmarkModel) ? "Saved" : "Bookmark it",
                systemImage: viewModel.isBookmarked(bookmarkModel) ? "bookmark.fill" : "bookmark"
            )
        }
        .tint(viewModel.isBookmarked(bookmarkModel) ? .black : .blue)
    }
    
    @ViewBuilder
    func sortingOptionView() -> some View {
        if !searchText.trim.isEmpty && !viewModel.books.isEmpty {
            HStack {
                Text("Sort by:")
                    .font(.headline)
                
                SortButton(title: "Title", selected: selectedSort == .title) {
                    selectedSort = .title
                }
                
                SortButton(title: "Publish Year", selected: selectedSort == .firstPublishYear) {
                    selectedSort = .firstPublishYear
                }
                
                SortButton(title: "Hits", selected: selectedSort == .authorName) {
                    selectedSort = .authorName
                }
            }
        }
    }
    
    @ViewBuilder
    func listView() -> some View {
        List {
          
                ForEach(0..<sortedBooks.count, id: \.self) { i in
                    HStack {
                        BookListCell(book: sortedBooks[i])
                            .swipeActions(edge: .trailing) {
                                swipeActionView(bookmarkModel: BookMarksModel(
                                    key: sortedBooks[i].key,
                                    coverI: sortedBooks[i].coverI ?? 0,
                                    author: sortedBooks[i].authorName?.first ?? "",
                                    title: sortedBooks[i].title,
                                    userEmail: viewModel.mailID
                                ))
                            }
                    }
                    .contentShape(Rectangle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .background()
                        .onTapGesture {
                            let bookDetail = (sortedBooks[i].key,
                                              sortedBooks[i].coverI ?? 0,
                                              viewModel.isBookmarked( BookMarksModel(
                                                key: sortedBooks[i].key,
                                                coverI: sortedBooks[i].coverI ?? 0,
                                                author: sortedBooks[i].authorName?.first ?? "",
                                                title: sortedBooks[i].title,
                                                userEmail: viewModel.mailID
                                              ))
                            )
                            router.navigateTo(.bookDetail(BookDetailsViewModel(bookDetail: bookDetail)))
                        }
                        .onAppear {
                            if i+1 == sortedBooks.count {
                                Task {
                                    try? await viewModel.fetchResults(searchQuery: searchText)
                                }
                            }
                        }
            }
        }
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
        .background(Color.white)
        
    }
    
    @ViewBuilder
    func headerView() -> some View {
        HStack(spacing: 12) {
            Image(systemName: "book.fill")
            Text("MedBook")
                .font(.largeTitle)
            Spacer()
            
            bookmarkCTA()
            logoutCTA()
        }
        .imageScale(.large)
        .foregroundStyle(.black)
        
        Text("Which topic interests you today?")
            .bold()
            .font(.title2)
    }
    
    
    func bookmarkCTA() -> some View {
        Button {
            viewModel.loadBookmarks()
            router.navigateTo(.bookmark(BookmarkViewModel(bookmarkedBooks: viewModel.bookmarkedBooks)))
        } label: {
            Image(systemName: "bookmark.fill")
                .foregroundStyle(.black)
        }
    }
    
    func logoutCTA() -> some View {
        Button {
            KeychainHelper.shared.delete(forKey: "isUserLoggedIn")
            router.popALL()
        } label: {
            Image(systemName: "xmark.square")
                .foregroundStyle(.red)
        }
    }
}

#Preview {
    HomeScreen()
        .environmentObject(Router())
}

