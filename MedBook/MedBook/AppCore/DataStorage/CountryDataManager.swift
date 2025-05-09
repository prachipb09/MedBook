//
//  CountryDataManager.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 17/03/25.
//
import SwiftData
import Foundation

@Model
class CountryList {
    var countriesData: Data // Store encoded array
    
    init(countries: [String]) {
        self.countriesData = (try? JSONEncoder().encode(countries)) ?? Data()
    }
    
        /// **Computed Property to Access Countries as an Array**
    var countries: [String] {
        get {
            (try? JSONDecoder().decode([String].self, from: countriesData)) ?? []
        }
        set {
            countriesData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }
}

@MainActor
class CountryDataManager {
    static let shared = CountryDataManager()
    let modelContext: ModelContext  // ✅ Uses shared context
    
    private init() {
        self.modelContext = SharedModelContainer.shared.modelContext
    }
    
        /// **Save the full country list** (Overwrites existing list)
    func saveCountriesList(countries: [String]) {
        if let existingList = fetchCountryListObject() {
            existingList.countries = countries // Update existing list
        } else {
            let countryList = CountryList(countries: countries)
            modelContext.insert(countryList)
        }
        
        do {
            try modelContext.save()
            print("Country list saved successfully!")
        } catch {
            print("Failed to save country list: \(error)")
        }
    }
    
        /// **Fetch country list as an array of Strings**
    func fetchCountriesList() -> [String] {
        return fetchCountryListObject()?.countries ?? []
    }
    
        /// **Helper to fetch the CountryList object**
    private func fetchCountryListObject() -> CountryList? {
        let fetchDescriptor = FetchDescriptor<CountryList>()
        return try? modelContext.fetch(fetchDescriptor).first
    }
    
        /// **Reset the country list (Deletes and re-adds)**
    func resetCountriesList() {
        if let existingList = fetchCountryListObject() {
            modelContext.delete(existingList)
        }
        do {
            try modelContext.save()
            print("Country list reset successfully!")
        } catch {
            print("Failed to reset country list: \(error)")
        }
    }
}
