//
//  ListView.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/14/22.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var persistence: PersistenceViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
    @Environment(\.dismissSearch) var dismissSearch
    @Environment(\.isSearching) var isSearching
    @Binding var isCelcius: Bool
    @State private var cityToDisplay: City?
    
    var body: some View {
        List {
            if let mainCity = persistence.city {
                InfoView(isCelcius: $isCelcius, city: mainCity)
                    .listRowBackground(backgroundColor(for: mainCity))
            }
            ForEach(persistence.cities) { city in
                CellView(city: city, isCelcius: $isCelcius) {
                    cityToDisplay = city
                }
                .listRowBackground(Color.background)
            }
            .onDelete { indexSet in
                persistence.deleteCity(offsets: indexSet)
            }
        }
        .sheet(item: $cityToDisplay) { city in
            DetailsView(city: city, isCelcius: $isCelcius)
        }
        .onChange(of: searchViewModel.searchText) { newValue in
            if newValue.isEmpty {
                searchViewModel.searchResults.removeAll()
                dismissSearch()
            }
        }
        .overlay {
            if !isSearching {
                helloText
            }
        }
    }
    
    func backgroundColor(for city: City) -> some View {
        switch city.temperature {
        case ..<283.15:
            return Color.customBlue
        case 283.16...298.15:
            return Color.customOrange
        default:
            return Color.customRed
        }
    }
    
    var helloText: some View {
        Text("Hello there! Start adding cities by searching them or tap on a location button to get weather for your city!")
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding()
            .opacity(persistence.cities.isEmpty ? 1 : 0)
    }
}
