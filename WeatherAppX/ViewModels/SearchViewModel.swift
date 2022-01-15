//
//  SearchViewModel.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/13/22.
//

import SwiftUI

final class SearchViewModel: ObservableObject {
    @Published var searchResults: [CityID] = []
    @Published var searchText: String = ""
    
    let allCities: [CityID] = Bundle.main.decode("city.list.json")
    
    func search() async {
        searchResults.removeAll()
        searchResults = allCities
            .filter({ cityId in
                return cityId.name.lowercased().contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
            })
            .sorted(by: { $0.country < $1.country })
    }
}
