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

    @State private var searchText = ""
    var body: some View {
        NavigationView {
            List {
                
            }
            .listStyle(.plain)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("City name"))
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
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
