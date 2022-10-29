//
//  UtilityFunctions.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 27.10.2022.
//

import Foundation
import SwiftUI

extension Bundle {
    func fetchWeatherData<T: Decodable>(
        latitude: Double,
        longitude: Double,
        model: T.Type,
        completion: @escaping(T) -> (),
        failure: @escaping(Error) -> ()
    ) {
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,relativehumidity_2m,windspeed_10m,weathercode") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    failure(error)
                }
                return
            }
            
            do {
                let serverData = try JSONDecoder().decode(T.self, from: data)
                
                completion(serverData)
            } catch {
                failure(error)
            }
        }
        .resume()
    }
    
    func getTemperatureWithUnit(temperature: Double, unit: TemperatureUnit) -> String {
        switch(unit){
        case .celsius:
            return "\(temperature)°C"
        case .fahrenheit:
            return "\(String(format: "%.1f", temperature*1.8 + 32))°F"
        }
    }
}

