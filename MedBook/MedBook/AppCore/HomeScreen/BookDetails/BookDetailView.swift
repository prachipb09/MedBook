//
//  BookDetailView.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 26/03/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookDetailView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel: BookDetailsViewModel
    @State var showError = false
    @State var showLoader: Bool = false
    @State var isBookMarked = false
    var body: some View {
        NavigationBar{
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Spacer()
                        bookmarkCTA()
                    }
                    HStack {
                        Spacer()
                        WebImage(url: URL(string: "https://covers.openlibrary.org/b/id/\(viewModel.bookDetail.coverKey)-M.jpg")) { image in
                            image.resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: 300, height: 300, alignment: .center)
                        } placeholder: {
                            Image(systemName: "book.closed")
                                .resizable()
                                .frame(width: 300, height: 300, alignment: .center)
                                .foregroundColor(.gray)
                                .opacity(0.5)
                        }
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        .cornerRadius(10)
                        Spacer()
                    }
                    if !showLoader {
                        HStack {
                            Text(viewModel.model?.title ?? "")
                                .font(.title)
                            Spacer()
                            Text(viewModel.model?.date ?? "")
                        }
                        
                        Text(viewModel.model?.author ?? "")
                            .font(.subheadline)
                        
                        Text(viewModel.model?.bookDescription ?? "")
                            .multilineTextAlignment(.leading)
                    } else {
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(.circular)
                            Spacer()
                        }
                    }
                }
                .padding(.all, 24)
                .onAppear {
                    fetchBookDetails()
                    isBookMarked = viewModel.bookDetail.isBookMarked
                }
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"),
                  message: Text("failed to fetch details"),
                  dismissButton: .default(Text("Close")){
                showError = false
            })
        }
    }

    func bookmarkCTA() -> some View {
        Button {
            isBookMarked.toggle()
            viewModel.bookMark()
        } label: {
            Image(systemName: isBookMarked ? "bookmark.fill" : "bookmark")
                .foregroundStyle(.black)
        }
    }
    
    private func fetchBookDetails() {
        Task {
            do {
                showLoader = true
                try await viewModel.isDataAvailabe()
            } catch {
                showError = true
            }
            showLoader = false
        }
    }
}

#Preview {
    BookDetailView(viewModel: BookDetailsViewModel(bookDetail: ("",1, false)))
        .environmentObject(Router())
}
