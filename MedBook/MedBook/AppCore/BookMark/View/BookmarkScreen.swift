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
                    // in case of no books are saved show the below message
                    Text("Oops... you don't have any saved books")
                    Spacer()
                } else {
                    listView()
                }
            }
            .padding(.all, 8)
            .onAppear {
                viewModel.loadBookmarks() 
            }
            .onReceive(NotificationCenter.default.publisher(for: .bookMarkChanged), perform: { _ in
                Task {
                    viewModel.loadBookmarks()
                }
            })
        }
    }
    
    @ViewBuilder
    func listView() -> some View {
        List(Array(viewModel.bookmarkedBooks).sorted { $0.title < $1.title }, id: \.key) { book in
            HStack {
                bookCoverImage(for: book.coverI)
                VStack(alignment: .leading) {
                    Text(book.title)
                        .bold()
                        .multilineTextAlignment(.leading)
                    Text(book.author)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
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
            .onTapGesture {
                router.navigateTo(.bookDetail(BookDetailsViewModel(bookDetail: (book.key, book.coverI, true))))
            }
        }
        .listStyle(.plain)
    }
}

#Preview() {
    BookmarkScreen(viewModel: BookmarkViewModel(bookmarkedBooks: []))
        .environmentObject(Router())
}
