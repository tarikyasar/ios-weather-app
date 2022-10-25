//
//  HourlyWeatherReportView.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 20.10.2022.
//

import SwiftUI
import ios_neumorphism

struct HourlyWeatherReportView: View {
    @Binding var isDarkModeEnabled: Bool
    var dailyReport: HourlyWeatherReport
    var width: CGFloat = 120
    var height: CGFloat = 120
    
    var body: some View {
        ZStack {
            NeumorphicSurface(
                surfaceShape: RoundedRectangle(cornerRadius: 20),
                isDarkModeEnabled: isDarkModeEnabled,
                width: width,
                height: height
            )
            
            VStack {
                Text(dailyReport.time)
                    .foregroundColor(.gray)
                    .font(.system(size: 18))
                
                Spacer()
                
                Image(systemName: dailyReport.weatherSymbolName)
                    .foregroundColor(.gray)
                    .font(.system(size: 34))
                
                Spacer()
                
                Text(dailyReport.temperature)
                    .foregroundColor(.gray)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                
            }
            .padding(.vertical, 10)
        }
        .frame(width: width, height: height)
    }
}

struct HourlyWeatherReportView_Preview_Container: View {
    @State var isDarkModeEnabled = false
    
    var body: some View {
        HourlyWeatherReportView(
            isDarkModeEnabled: $isDarkModeEnabled,
            dailyReport: HourlyWeatherReport(
                time: "00:00",
                temperature: "12C",
                humidity: "%43",
                windSpeed: "12 km/h",
                weatherSymbolName: "cloud.rain.fill",
                weatherInfo: "Rainy"
            )
        )
    }
}

struct HourlyWeatherReportView_Preview_Container_Previews: PreviewProvider {
    static var previews: some View {
        HourlyWeatherReportView_Preview_Container()
    }
}
