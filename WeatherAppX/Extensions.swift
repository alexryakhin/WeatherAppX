//
//  Extensions.swift
//  WeatherAppX
//
//  Created by Alexander Bonney on 5/12/21.
//

import Foundation
import SwiftUI
import UIKit

extension Bundle {
    // i use generic T type here to decode anything i want from almost any JSON Data file.
    // fatal error is bad for production, but while development, it's good because it should never happen
    func decode<T: Codable>(_ file: String) -> T {
        //getting lication of the file in our bundle and set temporary url constant
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        //setting temporary data constant with Data from the file I found in the bundle
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle")
        }
        //decoder instance
        let decoder = JSONDecoder()
        //loading data from my data constant
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bandle")
        }
        //returning this data as a generic type.
        return loaded
    }
}

func fetch<T: Codable>(_ type: T.Type, from url: URL) async throws -> T {
    let (data, response) = try await URLSession.shared.data(from: url)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
    let decodedData = try JSONDecoder().decode(T.self, from: data)
    return decodedData
}

extension Double {
    func convertTemperature(from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> Double {
        let input = Measurement(value: self, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return output.value
    }
}

extension Color {
    static let customBlue = Color("customBlue")
    static let customOrange = Color("customOrange")
    static let customRed = Color("customRed")
    static let background = Color("background")
}

enum WeatherError: Error {
    case cityIsInTheListAlready(String)
    case noLocationAccess(String)
    
    static let nothingFound = "Ooops.. Nothing found!"
}
