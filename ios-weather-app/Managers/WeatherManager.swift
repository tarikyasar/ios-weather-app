//
//  WeatherManager.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 29.10.2022.
//

import Foundation

class WeatherManager {
    func getWeatherData(latitude: Double, longitude: Double, _ completion:@escaping (WeatherReport) -> ()) {
        Bundle.main.fetchWeatherData(latitude: latitude, longitude: longitude, model: WeatherReport.self) { data in
            completion(data)
        } failure: { error in
            print(error)
        }
    }
}
