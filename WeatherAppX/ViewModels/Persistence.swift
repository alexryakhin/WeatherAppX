//
//  Persistence.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/12/22.
//

import CoreData
import SwiftUI
import CoreLocation

@MainActor
final class PersistenceViewModel: ObservableObject {
    private let container: NSPersistentContainer
    private let weatherService = WeatherService()
    
    @Published var city: City?
    @Published var cities: [City] = []
    
    //MARK: Life cycle
    init() {
        container = NSPersistentContainer(name: "WeatherAppX")
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
    private func fetchCities() {
        let request = NSFetchRequest<City>(entityName: "City")
        do {
            cities = try container.viewContext.fetch(request)
        } catch(let error) {
            print("Error fetching cities. \(error.localizedDescription)")
        }
        city = cities.first(where: { $0.isMainCity })
    }
    
    //MARK: Adding to the CoreData
    func addCity(_ city: CityID) async throws {
        let data = try await weatherService.getData(for: city.id)
        if cities.contains(where: { $0.identifier == data.id }) {
            throw WeatherError.cityIsInTheListAlready("This city is in your list already!")
        } else {
            let newCity = City(context: container.viewContext)
            newCity.identifier = Int32(data.id)
            newCity.name = data.name
            newCity.temperature = data.temperature
            newCity.feelsLike = data.feelsLike
            newCity.tempMax = data.tempMax
            newCity.tempMin = data.tempMin
            newCity.timestamp = Date(timeIntervalSince1970: (Date().timeIntervalSince1970 + Double(data.timeZone) - Double(TimeZone.current.secondsFromGMT())))
            newCity.isMainCity = false
            save()
        }
    }
    
    func addCity(_ location: CLLocationCoordinate2D) async throws {
        let data = try await weatherService.getData(for: location)
        let timestamp = Date(timeIntervalSince1970: (Date().timeIntervalSince1970 + Double(data.timeZone) - Double(TimeZone.current.secondsFromGMT())))
        if cities.contains(where: { $0.isMainCity }) {
            city?.name = data.name
            city?.temperature = data.temperature
            city?.feelsLike = data.feelsLike
            city?.tempMax = data.tempMax
            city?.tempMin = data.tempMin
            city?.timestamp = timestamp
        } else {
            let newCity = City(context: container.viewContext)
            newCity.identifier = Int32(data.id)
            newCity.name = data.name
            newCity.temperature = data.temperature
            newCity.feelsLike = data.feelsLike
            newCity.tempMax = data.tempMax
            newCity.tempMin = data.tempMin
            newCity.timestamp = timestamp
            newCity.isMainCity = true
        }
        save()
    }
    
    func updateAllCities() async throws {
        for city in cities {
            let data = try await weatherService.getData(for: Int(city.identifier))
            let timestamp = Date(timeIntervalSince1970: (Date().timeIntervalSince1970 + Double(data.timeZone) - Double(TimeZone.current.secondsFromGMT())))
            city.name = data.name
            city.temperature = data.temperature
            city.feelsLike = data.feelsLike
            city.tempMax = data.tempMax
            city.tempMin = data.tempMin
            city.timestamp = timestamp
        }
        save()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
            fetchCities()
        } catch let error {
            print("Error with saving data to CD. \(error.localizedDescription)")
        }
        objectWillChange.send()
    }
    
    //MARK: Removing from CD
    func deleteCity(offsets: IndexSet) {
        withAnimation {
            offsets.map { cities[$0] }.forEach(container.viewContext.delete)
            save()
        }
    }
}
