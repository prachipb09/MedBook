//
//  BookDetailsViewModel.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 26/03/25.
//

import SwiftUI
class BookDetailsViewModel: ObservableObject {
    let bookDetail: (key: String, coverKey: Int, isBookMarked: Bool)
    @Published var model: BookDetailResponse? = nil
    
    init(bookDetail: (String, Int, Bool), model: BookDetailResponse? = nil) {
        self.bookDetail = bookDetail
        self.model = model
    }
    
    private var mailID: String {
        KeychainHelper.shared.get(LoginUserData.self, forKey: "isUserLoggedIn")?.emailID ?? ""
    }
    
    @MainActor func bookMark() {
        BookmarkManager.shared.toggleBookmark(for: BookMarksModel(key: bookDetail.key, coverI: bookDetail.coverKey, author: model?.author ?? "", title: model?.title ?? "", userEmail: mailID), userEmail: mailID)
    }
    
    @MainActor
    func isDataAvailabe() async throws {
       let data = BookDetailDataManager.shared.fetchBook(byKey: bookDetail.key, coverI: bookDetail.coverKey, userEmail: mailID)
        if data == nil {
            do {
                try await fetchDetails(key: bookDetail.key)
                if model != nil && bookDetail.isBookMarked {
                    //insert to the db
                    try BookDetailDataManager.shared.saveBookDetail(for: BookDetailResponse(title: model?.title ?? "", author: model?.author ?? "", userEmail: mailID, date: model?.date ?? "", bookDescription: model?.bookDescription ?? "", key: bookDetail.key, coverI: bookDetail.coverKey))
                }
            } catch {
                throw error
            }
        } else {
            model = data
        }
    }
    
    @MainActor
    func fetchDetails(repo: BookDetailsRepo = BookDetailRepoImpl(), key: String) async throws {
        do {
            let response = try await repo.getBookDetail(restRepository: .bookDetail(key))
            model = BookDetailResponse(title: response.title ?? "", author: response.subjectPeople?.first ?? "", userEmail: mailID, date: response.firstPublishDate ?? "", bookDescription: response.description?.value ?? "", key: bookDetail.key, coverI: bookDetail.coverKey)
        } catch {
            throw error
        }
    }
}
