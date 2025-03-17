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
    @State private var selectedSort: SortOption = .title  // Default sorting option
    @State private var searchText: String = ""
    
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
                    TextField("Search your books....", text: $searchText)
                        // Sorting Options
                    sortingOptionView()
                }
                .padding()
                .onChange(of: $searchText.wrappedValue) { oldValue, newValue in
                    if searchText.count >= 3 && oldValue != newValue.trim {
                        Task {
                            await viewModel.fetchResults(searchQuery: searchText, reset: true)
                        }
                    } else {
                        viewModel.books = []
                    }
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
            Section {
                ForEach(0..<sortedBooks.count, id: \.self) { i in
                    BookListCell(book: sortedBooks[i])
                        .swipeActions(edge: .trailing) {
                            swipeActionView(bookmarkModel: BookMarksModel(
                                key: sortedBooks[i].key,
                                coverI: sortedBooks[i].coverI ?? 0,
                                author: sortedBooks[i].authorName?.first ?? "",
                                title: sortedBooks[i].title
                            ))
                        }
                        .onAppear {
                            if i+1 == sortedBooks.count {
                                Task {
                                    await viewModel.fetchResults(searchQuery: searchText)
                                }
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
            router.navigateTo(.bookmark(BookmarkViewModel(bookmarkedBooks: viewModel.bookmarkedBooks,
                                                          callback: { isBookmarkedBookUpdated in
                if isBookmarkedBookUpdated {
                    viewModel.loadBookmarks()
                }
            })))
        } label: {
            Image(systemName: "bookmark.fill")
                .foregroundStyle(.black)
        }
    }
    
    func logoutCTA() -> some View {
        Button {
            UserDefaultsManager.shared.save(false, forKey: "isUserLoggedIn")
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

