//
//  LoginScreen.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var router: Router
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showErrorAlert = false
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationBar {
            VStack(spacing: 24.0) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Welcome")
                            .font(.title)
                            .bold()
                        Text("login to continue...")
                    }
                    Spacer()
                }
                
                MBTextfield(heading: "Email",
                            placeholder: "Email",
                            textField: $email,
                            validation: { enteredText, isEditing in
                    viewModel.email = enteredText
                    return viewModel.isEmailValid || isEditing
                },
                            errorMessage: "incorrect email")
                
                MBTextfield(heading: "Password",
                            placeholder: "Password",
                            isSecureField: true,
                            textField: $password,
                            shouldShowRightImage: true,
                            validation: { enteredText, isEditing in
                    viewModel.password = enteredText
                    return viewModel.isPasswordValid || isEditing
                },
                            errorMessage: "empty password")
                
                MBPrimaryButton(title: "Login") {
                    if viewModel.checkCredentionalsValid(email: email, password: password) {
                        UserDefaultsManager.shared.save(true, forKey: "isUserLoggedIn")
                        router.navigateTo(.home)
                    } else {
                        showErrorAlert = true
                    }
                }
                
            }
            .padding()
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Login Error"),
                  message: Text("Invalid user credentials, please try again"))
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    LoginScreen()
        .environmentObject(Router())
}
