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

/*
 enum WeatherCode {
     case clear(symbolName: String = "sun.max.fill")
     case partlyCloudy(symbolName: String = "cloud.sun.fill")
     case foggy(symbolName: String = "cloud.fog.fill")
     case drizzle(symbolName: String = "cloud.drizzle.fill")
     case rain(symbolName: String = "cloud.rain.fill")
     case snowFall(symbolName: String = "cloud.snow.fill")
     case snowGrains(symbolName: String = "cloud.snow.fill")
     case rainShowers(symbolName: String = "cloud.bolt.rain.fill")
     case snowShowers(symbolName: String = "cloud.snow.fill")
     case thunderStorm(symbolName: String = "cloud.bolt.rain.fill")
 }
 */

func getWeatherSymbolName(number: Int) -> String {
    switch (number) {
    case 0:
        return "sun.max.fill"
    case 1...3:
        return "cloud.sun.fill"
    case 45...48:
        return "cloud.fog.fill"
    case 51...55:
        return "cloud.drizzle.fill"
    case 61...67:
        return "cloud.rain.fill"
    case 71...75:
        return "cloud.snow.fill"
    case 77:
        return "cloud.snow.fill"
    case 80...82:
        return "cloud.bolt.rain.fill"
    case 85...86:
        return "cloud.snow.fill"
    case 95...99:
        return "cloud.bolt.rain.fill"
    default:
        return "sun.max.fill"
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

