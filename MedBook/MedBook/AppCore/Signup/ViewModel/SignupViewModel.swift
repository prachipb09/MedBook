//
//  SignupViewModel.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 15/03/25.
//

import Foundation
import Combine



class SignupViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isEmailValid: Bool = false
    @Published var isPasswordValid: Bool = false
    @Published var countryList: [String] = []
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
            return $0.isValidPassword()
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
    
    
    func shouldAllowSignup() -> Bool {
        isEmailValid && isPasswordValid
    }
    
    @MainActor
    private func fetchCountryList(countryRepo: CountriesRepo = CountriesRepoImpl()) async throws -> Countries {
        do {
            return try await countryRepo.fetchCountries(restRepository: .countriesList)
        } catch {
            throw error
        }
    }
    
    func saveUserDetails(country: String) {
        MedBook.KeychainHelper.shared.save(UserCredentials(email: email, password: password, country: country), forKey: "user_credentials")
    }
    
    func saveCountriesList() {
        UserDefaults.standard.setValue(countryList, forKey: "storedCountries")
    }
    
    @MainActor
    func retriveList() async throws {
        if let savedCountries = UserDefaults.standard.array(forKey: "storedCountries") as? [String] {
            countryList = savedCountries
        } else {
            do {
                countryList = try await fetchCountryList().data.map { $0.value.country }.sorted()
                saveCountriesList()
            } catch {
                throw error
            }
        }
       
    }
}



extension String {
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return predicate.evaluate(with: self)
    }
}
