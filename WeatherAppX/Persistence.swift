//
//  Persistence.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/12/22.
//

import CoreData
import SwiftUI

class PersistenceViewModel: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
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
    }

}

