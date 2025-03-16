import SwiftUI

struct BookmarkScreen: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel: BookmarkViewModel
    
    var body: some View {
        NavigationBar {
            VStack(alignment: .leading) {
                Text("Your bookmarks....")
                    .font(.title)
                
                if viewModel.bookmarkedBooks.isEmpty {
                    Text("Oops... you don't have any saved books")
                    Spacer()
                } else {
                    List(Array(viewModel.bookmarkedBooks).sorted { $0.title < $1.title }, id: \.key) { book in
                        HStack {
                            if let uiImage = book.uiImage {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            }
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .bold()
                                Text(book.author)
                                    .foregroundColor(.gray)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                viewModel.removeBookmark(for: book)
                            } label: {
                                Label("Remove", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .padding(.all, 8)
            .onAppear {
                viewModel.loadBookmarks() // Ensure bookmarks are loaded
            }
        }
    }
}

#Preview() {
    BookmarkScreen(viewModel: BookmarkViewModel(bookmarkedBooks: [], callback: { _ in }))
        .environmentObject(Router())
}


#Preview() {
    BookmarkScreen(viewModel: BookmarkViewModel(bookmarkedBooks: [], callback: { _ in }))
        .environmentObject(Router())
}
