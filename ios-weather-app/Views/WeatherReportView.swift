//
//  WeatherReportView.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 26.10.2022.
//

import SwiftUI
import ios_neumorphism

struct WeatherReportView: View {
    @State var refreshViewBackgroundColor = Color.gray
    @State var yOffSet: CGFloat = 0
    @Binding var isDarkModeEnabled: Bool
    var cityName: String
    var time: String
    var onRefresh: () -> Void
    var dailyReports: [HourlyWeatherReport]
    var temperatureUnit: TemperatureUnit
    var weatherReport: WeatherReport
    
    var body: some View {
        VStack {
            Text(cityName)
                .font(.system(size: 40))
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            Text(time)
                .font(.system(size: 30))
                .fontWeight(.medium)
                .foregroundColor(.gray)
        }
        .padding(.top, 40)
        
        Spacer()
        
        CurrentWeatherView(
            isDarkModeEnabled: $isDarkModeEnabled,
            dailyReport: dailyReports[0],
            weatherReport: weatherReport,
            targetTemperatureUnit: temperatureUnit,
            onRefresh: {
                onRefresh()
            }
        )
        .padding(.bottom, 40)
        
        ZStack {
            NeumorphicPressedSurface(
                surfaceShape: RoundedRectangle(cornerRadius: 16),
                isDarkModeEnabled: isDarkModeEnabled,
                width: .infinity,
                height: 120
            )
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 25) {
                    ForEach(dailyReports, id: \.self) { dailyReport in
                        HourlyWeatherReportView(
                            dailyReport: dailyReport,
                            targetTemperatureUnit: temperatureUnit
                        )
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 50)
            }
        }.padding(.horizontal, 20)
        
        Spacer()
    }
}
