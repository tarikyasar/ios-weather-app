//
//  ViewModel.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 20.10.2022.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    private let weatherManager = WeatherManager()
    
    @Published var weatherReport: WeatherReport = WeatherReport.sampleWeatherReport
    @Published var dailyReport: [HourlyWeatherReport] = []
    @Published var isLoading = true
    
    func fetchWeatherReport(latitude: Double, longitude: Double) {
        isLoading = true
        
        weatherManager.getWeatherData(latitude: latitude, longitude: longitude) { weatherReport in
            DispatchQueue.main.async {
                self.dailyReport = []
                self.weatherReport = weatherReport
                self.isLoading = false
                
                self.getDailyReport()
            }
        }
    }
    
    func getDailyReport() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        for number in hour..<(24+hour) {
            let hourly = weatherReport.hourly
            let hour = hourly.time[number].components(separatedBy: "T").last!
            let weatherInfo = getWeatherSymbolName(
                number: hourly.weathercode[number],
                hour: Int(hour.components(separatedBy: ":").first!) ?? 0
            )
            
            self.dailyReport.append(
                HourlyWeatherReport(
                    time: hour,
                    temperature: hourly.temperature_2m[number],
                    humidity: "\(hourly.relativehumidity_2m[number])\(weatherReport.hourly_units.relativehumidity_2m)",
                    windSpeed: "\(hourly.windspeed_10m[number])\(weatherReport.hourly_units.windspeed_10m)",
                    weatherSymbolName: weatherInfo.0,
                    weatherInfo: weatherInfo.1
                )
            )
        }
    }
}
