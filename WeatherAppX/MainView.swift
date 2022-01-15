//
//  MainView.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/12/22.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var persistence: PersistenceViewModel
    @StateObject var searchViewModel = SearchViewModel()
    @StateObject var locationManager = LocationManager()
    @AppStorage("isCelcius") var isCelcius: Bool = false
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ListView(isCelcius: $isCelcius)
                .environmentObject(persistence)
                .environmentObject(searchViewModel)
                .listStyle(.plain)
                .searchable(text: $searchViewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("City name"), suggestions: { suggestions })
                .navigationTitle("Weather")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) { locationButton }
                }
                .onSubmit(of: .search) {
                    Task {
                        await searchViewModel.search()
                        if searchViewModel.searchResults.isEmpty {
                            showAlert(with: WeatherError.nothingFound)
                        }
                    }
                }
                .onReceive(timer) { _ in
                    Task {
                        do {
                            try await persistence.updateAllCities()
                        } catch {
                            showAlert(for: error)
                        }
                    }
                }
                .task {
                    do {
                        try await persistence.updateAllCities()
                    } catch {
                        showAlert(for: error)
                    }
                }
                .alert(alertMessage, isPresented: $isShowingAlert) {
                    Button("OK", role: .cancel) {
                        searchViewModel.searchText = ""
                    }
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func showAlert(for error: Error) {
        isShowingAlert = true
        alertMessage = error.localizedDescription
    }
    
    private func showAlert(with message: String) {
        isShowingAlert = true
        alertMessage = message
    }
    
    private var locationButton: some View {
        Button {
            Task {
                do {
                    try locationManager.requestLocation()
                    if let location = locationManager.location {
                        try await persistence.addCity(location)
                    }
                } catch WeatherError.noLocationAccess(let errorMessage) {
                    showAlert(with: errorMessage)
                } catch {
                    showAlert(for: error)
                }
            }
        } label: {
            Image(systemName: "location.north.circle")
        }
    }
    
    private var suggestions: some View {
        ForEach(searchViewModel.searchResults) { cityId in
            Button {
                Task {
                    do {
                        try await persistence.addCity(cityId)
                        searchViewModel.searchText = ""
                    } catch WeatherError.cityIsInTheListAlready(let errorMessage) {
                        showAlert(with: errorMessage)
                    } catch let error {
                        showAlert(for: error)
                    }
                }
            } label: {
                if !cityId.state.isEmpty {
                    Text(cityId.name + ", " + cityId.state + ", " + cityId.country)
                } else {
                    Text(cityId.name + ", " + cityId.country)
                }
            }
            .foregroundColor(Color.primary)
        }
    }
}
