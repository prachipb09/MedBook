//
//  Screens.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import Foundation

enum Screens {
    case login
    case signup
    case home
    case bookDetail(BookDetailsViewModel)
    case bookmark(BookmarkViewModel)
}

extension Screens: Hashable,Equatable {
    static func == (lhs: Screens, rhs: Screens) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
            case .login:
                hasher.combine(UUID())
            case .signup:
                hasher.combine(UUID())
            case .home:
                hasher.combine(UUID())
            case .bookmark:
                hasher.combine(UUID())
            case .bookDetail:
                hasher.combine(UUID())
        }
    }
}
