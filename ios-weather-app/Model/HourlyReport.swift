//
//  HourlyReport.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 20.10.2022.
//

import Foundation
import SwiftUI

struct HourlyReport: Hashable, Codable {
    let time: [String]
    let temperature_2m: [Double]
    let relativehumidity_2m: [Double]
    let windspeed_10m: [Double]
    let weathercode: [Int]
}


func getWeatherSymbolName(number: Int, hour: Int) -> (String, String) {
    let dayLightRange = 6...18
    
    switch (number) {
    case 0:
        return (dayLightRange.contains(hour) ? "sun.max.fill" : "moon.stars.fill", "Clear")
    case 1...3:
        return (dayLightRange.contains(hour) ? "cloud.sun.fill" : "cloud.moon.fill", "Partly Cloudy")
    case 45...48:
        return ("cloud.fog.fill", "Foggy")
    case 51...55:
        return ("cloud.drizzle.fill", "Drizzle")
    case 61...67:
        return ("cloud.rain.fill", "Rainy")
    case 71...75:
        return ("cloud.snow.fill", "Snowfall")
    case 77:
        return ("cloud.snow.fill", "Snow Grains")
    case 80...82:
        return ("cloud.bolt.rain.fill", "Showering Rain")
    case 85...86:
        return ("cloud.snow.fill", "Showering Snow")
    case 95...99:
        return ("cloud.bolt.rain.fill", "Thunderstrom")
    default:
        return (dayLightRange.contains(hour) ? "sun.max.fill" : "moon.stars.fill", "Clear")
    }
}


/*
 func getWeatherSymbolName(number: Int) -> WeatherCode {
     switch (number) {
     case 0:
         return .clear()
     case 1...3:
         return .partlyCloudy()
     case 45...48:
         return .foggy()
     case 51...55:
         return .drizzle()
     case 61...67:
         return .rain()
     case 71...75:
         return .snowFall()
     case 77:
         return .snowGrains()
     case 80...82:
         return .rainShowers()
     case 85...86:
         return .snowShowers()
     case 95...99:
         return .thunderStorm()
     default:
         return .clear()
     }
 }
 */

