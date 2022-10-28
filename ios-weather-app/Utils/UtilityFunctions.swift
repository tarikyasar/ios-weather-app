//
//  UtilityFunctions.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 27.10.2022.
//

import Foundation
import SwiftUI

func getTemperatureWithUnit(temperature: Double, unit: TemperatureUnit) -> String {
    switch(unit){
    case .celsius:
        return "\(temperature)°C"
    case .fahrenheit:
        return "\(String(format: "%.1f", temperature*1.8 + 32))°F"
    }
}
