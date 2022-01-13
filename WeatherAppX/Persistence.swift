//
//  Persistence.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/12/22.
//

import CoreData
import SwiftUI

@MainActor
class PersistenceViewModel: ObservableObject {
    let container: NSPersistentCloudKitContainer
    let weatherService = WeatherService()
    
    @Published var city: City?
    @Published var cities: [City] = []
    
    //MARK: Life cycle
    init() {
        container = NSPersistentCloudKitContainer(name: "WeatherAppX")
        container.loadPersistentStores(completionHandler: { description, error in
            if let error = error {
                print("ERROR LOADING CORE DATA, \(error.localizedDescription)")
            } else {
                print("Successfully loaded core data!")
            }
        })
        fetchCities()
    }
    
    //MARK: Fetching
    func fetchCities() {
        let request = NSFetchRequest<City>(entityName: "City")
        do {
            cities = try container.viewContext.fetch(request)
        } catch(let error) {
            print("Error fetching videos. \(error.localizedDescription)")
        }
        city = cities.first(where: { $0.isMainCity })
    }

    func addCity(_ city: CityID) async throws {
        let data = try await weatherService.getData(for: city)
        let newCity = City(context: container.viewContext)
        newCity.identifier = Int32(data.id)
        newCity.name = data.name
        newCity.temperature = data.temperature
        newCity.timestamp = Date(timeIntervalSince1970: (Date().timeIntervalSince1970 + Double(data.timeZone) - Double(TimeZone.current.secondsFromGMT())))
        newCity.isMainCity = cities.count < 1
        save()
    }
    
    func save() {
        do {
            try container.viewContext.save()
            fetchCities()
        } catch let error {
            print("Error with saving data to CD. \(error.localizedDescription)")
        }
        objectWillChange.send()
    }
}

