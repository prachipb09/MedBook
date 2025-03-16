//
//  SortButton.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import SwiftUI

struct SortButton: View {
    let title: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(selected ? .white : .black)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selected ? Color.blue : Color.gray.opacity(0.3))
                )
        }
    }
}
