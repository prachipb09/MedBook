//
//  NavigationBar.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import SwiftUI

struct NavigationBar<Content: View>: View {
    @EnvironmentObject var router: Router
    var hideBackButton: Bool = false
    @ViewBuilder var content: Content
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Screens.self) { destination in
                    switch destination {
                        case .home:
                            HomeScreen()
                        case .login:
                            LoginScreen()
                        case .signup:
                            SignupScreen()
                        case .bookmark(let viewModel):
                            BookmarkScreen(viewModel: viewModel)
                        case .bookDetail(let viewModel):
                            BookDetailView(viewModel: viewModel)
                    }
                }
        }
        .navigationBarBackButtonHidden(hideBackButton)
    }
}

#Preview {
    NavigationBar(content: {
        
    })
        .environmentObject(Router())
}
