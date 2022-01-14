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
    
    var body: some View {
        NavigationView {
            ListView(isCelcius: $isCelcius)
                .environmentObject(persistence)
                .environmentObject(searchViewModel)
                .listStyle(.plain)
                .searchable(text: $searchViewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("City name"))
                .navigationTitle("Weather")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            Task {
                                do {
                                    locationManager.requestLocation()
                                    if let location = locationManager.location {
                                        try await persistence.addCity(location)
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        } label: {
                            Image(systemName: "location.north.circle")
                        }
                    }
                }
                .onSubmit(of: .search) {
                    withAnimation {
                        searchViewModel.search()
                    }
                }
                .onReceive(timer) { _ in
                    Task {
                        do {
                            try await persistence.updateAllCities()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                .task {
                    do {
                        try await persistence.updateAllCities()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
        }
    }
}

struct ListView: View {
    @EnvironmentObject var persistence: PersistenceViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
    @Environment(\.isSearching) var isSearching
    @Environment(\.dismissSearch) var dismissSearch
    @Binding var isCelcius: Bool

    var body: some View {
        if !isSearching {
                List {
                    if let mainCity = persistence.city {
                        InfoView(isCelcius: $isCelcius, city: mainCity)
                            .listRowBackground(Color.blue.opacity(0.4))
                    }
                    ForEach(persistence.cities) { city in
                        CellView(city: city, isCelcius: $isCelcius) {
                            // make it main
                            print("button pressed")
                        }
                        .listRowBackground(Color.white)
                    }
                    .onDelete { indexSet in
                        persistence.deleteCity(offsets: indexSet)
                    }
                }
            
        } else {
            List(searchViewModel.searchResults) { cityId in
                Button {
                    Task {
                        do {
                            try await persistence.addCity(cityId)
                            searchViewModel.searchText = ""
                            searchViewModel.searchResults.removeAll()
                            dismissSearch()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } label: {
                    Text(cityId.name + ", " + cityId.country)
                }
            }
        }
    }
}
