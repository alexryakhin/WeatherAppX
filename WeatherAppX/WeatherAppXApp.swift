//
//  WeatherAppXApp.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/12/22.
//

import SwiftUI

@main
struct WeatherAppXApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
