//
//  HourlyWeatherReport.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 20.10.2022.
//

import Foundation
import SwiftUI

struct HourlyWeatherReport: Hashable {
    let time: String
    let temperature: Int
    let humidity: String
    let windSpeed: String
    let weatherSymbolName: String
    let weatherInfo: String
    
    static var sampleHourlyWeatherReport = HourlyWeatherReport(
        time: "12:00",
        temperature: 12,
        humidity: "%60",
        windSpeed: "12 km/h",
        weatherSymbolName: "clear",
        weatherInfo: "Clear"
    )
}
