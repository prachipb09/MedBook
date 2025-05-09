//
//  LoginViewModel.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isEmailValid: Bool = false
    @Published var isPasswordValid: Bool = false
    var cancelable = Set<AnyCancellable>()
    
    init() {
        initialise()
    }
    
    func initialise() {
        checkPasswordValid()
        checkEmailValidity()
    }
    
    func checkPasswordValid() {
        $password.map {
            return $0.count >= 1
        }
        .assign(to: \.isPasswordValid, on: self)
        .store(in: &cancelable)
    }
    
    func checkEmailValidity() {
        $email.map {
            return $0.isValidEmail()
        }
        .assign(to: \.isEmailValid, on: self)
        .store(in: &cancelable)
    }
    
    @MainActor
    func checkCredentionalsValid(email: String, password: String) -> Bool {
        guard let retrievedCredentials = UserDataManager.shared.fetchUserByEmail(email: email)  else {
            return false
        }
        return retrievedCredentials.password == password ? true : false
    }
}
