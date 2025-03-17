//
//  ContentView.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import SwiftUI

struct LandingScreen: View {
    @EnvironmentObject var router: Router
    var body: some View {
        NavigationBar {
            VStack {
                Spacer()
                    .frame(height: 80)
                HStack {
                    Image(systemName: "medical.thermometer.fill")
                    Text("MedBook")
                        .font(.largeTitle)
                    Image(systemName: "book")
                }
                .imageScale(.large)
                .foregroundStyle(.black)
                
                Spacer()
                
                HStack(spacing: 60) {
                    MBPrimaryButton(title: "Signup", action: {
                        router.navigateTo(.signup)
                    })
                    MBPrimaryButton(title: "Login", action: {
                        router.navigateTo(.login)
                    })
                }
                
                Spacer()
                    .frame(height: 80)
                
            }
            .onAppear(perform: {
                //perform autologin
                if KeychainHelper.shared.get(LoginUserData.self, forKey: "isUserLoggedIn")?.isLogged ?? false {
                    router.navigateTo(.home)
                }
            })
            .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
            .background(.gray.opacity(0.3))
        }
    }
}

#Preview {
    LandingScreen()
        .environmentObject(Router())
}
