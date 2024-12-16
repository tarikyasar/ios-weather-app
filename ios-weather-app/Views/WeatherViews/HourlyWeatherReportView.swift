//
//  HourlyWeatherReportView.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 20.10.2022.
//

import SwiftUI
import ios_neumorphism

struct HourlyWeatherReportView: View {
    var dailyReport: HourlyWeatherReport
    var targetTemperatureUnit: TemperatureUnit
    
    var body: some View {
        VStack {
            Text(dailyReport.time)
                .foregroundColor(.gray)
                .font(.system(size: 18))
            
            Image(systemName: dailyReport.weatherSymbolName)
                .foregroundColor(.gray)
                .font(.system(size: 34))

            Text(Bundle.main.getTemperatureWithUnit(temperature: dailyReport.temperature, unit: targetTemperatureUnit))
                .foregroundColor(.gray)
                .font(.system(size: 20))
                .fontWeight(.medium)
        }
    }
}

struct HourlyWeatherReportView_Preview_Container: View {
    var body: some View {
        HourlyWeatherReportView(
            dailyReport: HourlyWeatherReport(
                time: "00:00",
                temperature: 12,
                humidity: "%43",
                windSpeed: "12 km/h",
                weatherSymbolName: "cloud.rain.fill",
                weatherInfo: "Rainy"
            ),
            targetTemperatureUnit: TemperatureUnit.fahrenheit
        )
    }
}

struct HourlyWeatherReportView_Preview_Container_Previews: PreviewProvider {
    static var previews: some View {
        HourlyWeatherReportView_Preview_Container()
    }
}
