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
    
    @MainActor
    func shouldAllowSignup() -> Bool {
        isEmailValid && isPasswordValid && UserDataManager.shared.fetchUserByEmail(email: email) == nil
    }
    
    @MainActor
    private func fetchCountryList(countryRepo: CountriesRepo = CountriesRepoImpl()) async throws -> Countries {
        do {
            return try await countryRepo.fetchCountries(restRepository: .countriesList)
        } catch {
            throw error
        }
    }
    
    func saveDefaultCountry(country: String) {
        UserDefaultsManager.shared.save(country, forKey: "defaultCountry")
    }
    
    func loadDefaultCountry() -> String {
        UserDefaultsManager.shared.load(String.self, forKey: "defaultCountry") ?? ""
    }
    
    @MainActor
    func saveUserDetails(country: String) {
        saveDefaultCountry(country: country)
        UserDataManager.shared.saveUser(email: email, password: password, country: country)
    }
    
    @MainActor
    func saveCountriesList() {
        CountryDataManager.shared.saveCountriesList(countries: countryList)
    }
    
    @MainActor
    func retriveList() async throws {
        let savedCountries = CountryDataManager.shared.fetchCountriesList()
        if !savedCountries.isEmpty {
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
