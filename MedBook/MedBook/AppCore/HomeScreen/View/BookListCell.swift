//
//  BookListCell.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 17/03/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookListCell: View {
    let book: Doc
    
    var body: some View {
        HStack(spacing: 0) {
            bookCoverImage(for: book.coverI ?? 0)
            VStack(alignment: .leading, spacing: 10) {
                Text(book.title)
                    .font(.headline)
                    .bold()
                    .multilineTextAlignment(.leading)
                Text("\(book.authorName?.first ?? "")")
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            Spacer()
        }
        .background(.white)
        .cornerRadius(10)
        .frame(height: 65)
    }
}

#Preview {
    BookListCell(
        book: Doc(authorKey: ["key"], authorName: ["author"], coverEditionKey: nil, coverI: 12423, editionCount: 9, firstPublishYear: 0, hasFulltext: false, ia: [], iaCollectionS: "", key: "", language: [], lendingEditionS: "", lendingIdentifierS: "", publicScanB: false, title: "title", subtitle: "subtitle")
    )
}
