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
    let temperature: String
    let humidity: String
    let windSpeed: String
    let weatherSymbolName: String
    let weatherInfo: String
}
