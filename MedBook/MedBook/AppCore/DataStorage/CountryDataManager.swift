//
//  CountryDataManager.swift
//  MedBook
//
//  Created by Prachi Bharadwaj on 17/03/25.
//


import SwiftData
import Foundation
import SwiftData
import Foundation
import SwiftData
import Foundation

@Model
class CountryList {
    var countries: [String]
    
    init(countries: [String]) {
        self.countries = countries
    }
}

@MainActor
class CountryDataManager {
    static let shared = CountryDataManager()
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    private init() {
        do {
            modelContainer = try ModelContainer(for: CountryList.self)
            modelContext = modelContainer.mainContext
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
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
