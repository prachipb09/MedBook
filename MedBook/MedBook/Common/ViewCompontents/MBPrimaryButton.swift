//
//  MBPrimaryButton.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import SwiftUI

struct MBPrimaryButton: View {
    let title: String
    let action: ()->Void
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Text(title)
                    .bold()
                    .padding(.vertical, 8)
                    .padding(.horizontal, 48)
                    .foregroundStyle(.black)
                    .background(.white)
                    .border(.black, width: 2)
            }
        }
    }
}
#Preview() {
    MBPrimaryButton(title: "test", action: {
        
    })
}
