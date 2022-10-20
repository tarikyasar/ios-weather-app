//
//  WeatherReport.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 20.10.2022.
//

import Foundation
import SwiftUI

struct WeatherReport: Hashable, Codable {
    let latitude: Double
    let longitude: Double
    let elevation: Double
    let hourly_units: HourlyUnits
    let hourly: HourlyReport
}
