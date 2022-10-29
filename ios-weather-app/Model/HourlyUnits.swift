//
//  HourlyUnits.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 20.10.2022.
//

import Foundation
import SwiftUI

struct HourlyUnits: Hashable, Codable {
    let temperature_2m: String
    let relativehumidity_2m: String
    let windspeed_10m: String
    
    static var sampleHourlyUnits = HourlyUnits(temperature_2m: "°C", relativehumidity_2m: "%", windspeed_10m: "km/h")
}
