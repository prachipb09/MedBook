    //
    //  SignupScreen.swift
    //  MedBook
    //
    //  Created by Prachi Bharadwaj on 15/03/25.
    //

import SwiftUI

struct SignupScreen: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel = SignupViewModel()
    @State private var list: [String] = [""]
    @State private var country: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showErrorAlert: (show: Bool, message: String) = (false, "")
    
    var body: some View {
        NavigationBar {
            ScrollView {
                VStack(alignment: .center, spacing: 28.0) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Welcome")
                                .font(.title)
                                .bold()
                            Text("sign up to continue...")
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
                                errorMessage: "Minimum 8 Characters, At least 1 number, At least 1 Uppercase Character, At least 1 Special Character")
                    
                    HStack {
                        Text("Country :\t")
                        Text(country)
                        Spacer()
                    }
                    
                    Picker("", selection: $country) {
                        ForEach(list, id: \.self) { value in
                            Text(value)
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    MBPrimaryButton(title: "Let's go -->") {
                        let (isValidDetails, errorMessage) = viewModel.shouldAllowSignup(selectedCountry: country)
                        if isValidDetails {
                            viewModel.saveUserDetails(country: country)
                            router.navigateTo(.home)
                        } else {
                            showErrorAlert = (true, errorMessage)
                        }
                    }
                }
                .padding()
            }
            .padding(.vertical, 8)
            .onAppear {
                getCountriesList()
                country = viewModel.loadDefaultCountry() ?? "Select a country..."
            }
            .onChange(of: country, {
                viewModel.saveDefaultCountry(country: country)
            })
            .alert(isPresented: $showErrorAlert.show) {
                Alert(title: Text("Login Error"),
                      message: Text(showErrorAlert.message),
                      dismissButton: .default(Text("Close")){
                    showErrorAlert = (false, "")
                })
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private func getCountriesList() {
        Task {
            do {
                try await viewModel.retriveList()
                list = viewModel.countryList
            } catch {
                
            }
        }
    }
}

#Preview {
    SignupScreen()
        .environmentObject(Router())
}
