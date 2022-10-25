//
//  ViewModel.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 20.10.2022.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var weatherReport: WeatherReport = WeatherReport(
        latitude: 0.0,
        longitude: 0.0,
        elevation: 0.0,
        hourly_units: HourlyUnits(temperature_2m: "", relativehumidity_2m: "", windspeed_10m: ""),
        hourly: HourlyReport(
            time: [""],
            temperature_2m: [0.0],
            relativehumidity_2m: [0.0],
            windspeed_10m: [0.0],
            weathercode: [0]
        )
    )
    @Published var dailyReport: [HourlyWeatherReport] = []
    @Published var isLoading = true
    
    func fetchWeatherReport(latitude: Double, longitude: Double) {
        isLoading = true
        
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,relativehumidity_2m,windspeed_10m,weathercode") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let weatherReport = try JSONDecoder().decode(WeatherReport.self, from: data)
                
                DispatchQueue.main.async {
                    self?.dailyReport = []
                    self?.weatherReport = weatherReport
                    self?.isLoading = false
                    
                    let hour = Calendar.current.component(.hour, from: Date())
                    
                    for number in hour..<(24+hour) {
                        let hourly = weatherReport.hourly
                        let hour = hourly.time[number].components(separatedBy: "T").last!
                        let weatherInfo = getWeatherSymbolName(
                            number: hourly.weathercode[number],
                            hour: Int(hour.components(separatedBy: ":").first!) ?? 0
                        )
                        
                        self?.dailyReport.append(
                            HourlyWeatherReport(
                                time: hour,
                                temperature: "\(hourly.temperature_2m[number])\(weatherReport.hourly_units.temperature_2m)",
                                humidity: "\(hourly.relativehumidity_2m[number])\(weatherReport.hourly_units.relativehumidity_2m)",
                                windSpeed: "\(hourly.windspeed_10m[number])\(weatherReport.hourly_units.windspeed_10m)",
                                weatherSymbolName: weatherInfo.0,
                                weatherInfo: weatherInfo.1
                            )
                        )
                    }
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}
