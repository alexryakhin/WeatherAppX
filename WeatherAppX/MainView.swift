//
//  MainView.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/12/22.
//

import SwiftUI
import CoreData
import MapKit
import CoreLocation

struct MainView: View {
    @EnvironmentObject var persistence: PersistenceViewModel
    @StateObject var searchViewModel = SearchViewModel()
    @AppStorage("isCelcius") var isCelcius: Bool = false
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
                            print("location button pressed")
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
            ScrollView {
                VStack(spacing: 0) {
                    if let mainCity = persistence.city {
                        InfoView(isCelcius: $isCelcius, city: mainCity)
                    }
                    ForEach(persistence.cities) { city in
                        CellView(city: city, isCelcius: $isCelcius) {
                            // make it main
                        }
                        .padding()
                        Divider().padding(.leading)
                    }
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
