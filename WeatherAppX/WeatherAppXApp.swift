//
//  WeatherAppXApp.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/12/22.
//

import SwiftUI

@main
struct WeatherAppXApp: App {
    @StateObject var persistenceViewModel = PersistenceViewModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(persistenceViewModel)
        }
    }
}
