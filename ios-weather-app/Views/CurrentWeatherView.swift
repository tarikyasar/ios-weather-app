//
//  CurrentWeatherView.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 20.10.2022.
//

import SwiftUI
import ios_neumorphism

struct CurrentWeatherView: View {
    @Binding var isDarkModeEnabled: Bool
    var dailyReport: HourlyWeatherReport
    var width: CGFloat = 100
    var height: CGFloat = 100
    
    var body: some View {
        ZStack {
            NeumorphicSurface(
                surfaceShape: RoundedRectangle(
                cornerRadius: 40),
                isDarkModeEnabled: isDarkModeEnabled,
                width: 270,
                height: 270
            )
            
            VStack {
                Spacer()
                
                Text("\(dailyReport.temperature)")
                    .foregroundColor(.gray)
                    .fontWeight(.medium)
                    .font(.system(size: 42))
                
                Spacer()
                
                ZStack {
                    NeumorphicPressedSurface(
                        surfaceShape: Circle(),
                        isDarkModeEnabled: isDarkModeEnabled,
                        width: width,
                        height: height
                    )
                    
                    Image(systemName: dailyReport.weatherSymbolName)
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(NSLocalizedString(dailyReport.weatherInfo, comment: ""))
                    .foregroundColor(.gray)
                    .font(.system(size: 30))
                    .fontWeight(.medium)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    HStack {
                        Image(systemName: "wind")
                            .foregroundColor(.gray)
                            .font(.system(size: 20))
                        
                        Text(dailyReport.windSpeed)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "drop.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 20))
                        
                        Text(dailyReport.humidity)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            .frame(width: 250, height: 250)
        }
    }
}

struct CurrentWeatherView_Preview_Container: View {
    @State var isDarkModeEnabled = false
    
    var body: some View {
        CurrentWeatherView(
            isDarkModeEnabled: $isDarkModeEnabled,
            dailyReport: HourlyWeatherReport(
                time: "00:00",
                temperature: "12°C",
                humidity: "%43",
                windSpeed: "12 km/h",
                weatherSymbolName: "cloud.rain.fill",
                weatherInfo: "Rainy"
            )
        )
    }
}

struct CurrentWeatherView_Preview_Container_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView_Preview_Container()
    }
}
