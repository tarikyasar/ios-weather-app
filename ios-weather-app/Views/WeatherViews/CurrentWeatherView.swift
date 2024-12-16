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
    var weatherReport: WeatherReport
    var targetTemperatureUnit: TemperatureUnit
    var onRefresh: () -> Void
    var width: CGFloat = 100
    var height: CGFloat = 100
    @State var refreshViewBackgroundColor = Color.gray
    @State var yOffSet: CGFloat = 0
    
    var body: some View {
        ZStack {
            NeumorphicSurface(
                surfaceShape: RoundedRectangle(cornerRadius: 40),
                isDarkModeEnabled: isDarkModeEnabled,
                width: 270,
                height: 270
            )
            
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(refreshViewBackgroundColor)
                    .frame(width: 270, height: 270)
                
                VStack {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(-yOffSet*8), anchor: .center)
                        .padding(.top, 5)
                    
                    Spacer()
                }
                .frame(width: 270, height: 270)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color("BackgroundColor"))
                    .frame(width: 270, height: 270)
                
                VStack {
                    Spacer()
                    
                    Text(Bundle.main.getTemperatureWithUnit(temperature: dailyReport.temperature, unit: targetTemperatureUnit))
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
                    
                    Text("H: \(Bundle.main.getTemperatureWithUnit(temperature: weatherReport.getHeighestTemperature(), unit: targetTemperatureUnit)) L: \(Bundle.main.getTemperatureWithUnit(temperature: weatherReport.getLowestTemperature(), unit: targetTemperatureUnit))")
                        .foregroundColor(.gray)
                    
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
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onChanged { value in
                    let verticalAmount = value.translation.height >= 0 ? value.translation.height/2 : 0
                    
                    yOffSet = verticalAmount <= 45 ? verticalAmount : 45
                    refreshViewBackgroundColor = verticalAmount >= 45 ? Color.green : Color.gray
                }
                .onEnded { value in
                    yOffSet = 0
                        
                    if (value.translation.height >= 45) {
                        onRefresh()
                    }
                }
            )
            .offset(y: yOffSet)
            
        }
    }
}

struct CurrentWeatherView_Preview_Container: View {
    @State var isDarkModeEnabled = false
    
    var body: some View {
        CurrentWeatherView(
            isDarkModeEnabled: $isDarkModeEnabled,
            dailyReport: HourlyWeatherReport.sampleHourlyWeatherReport,
            weatherReport: WeatherReport.sampleWeatherReport,
            targetTemperatureUnit: TemperatureUnit.fahrenheit,
            onRefresh: {
                print("Refreshed.")
            }
        )
    }
}

struct CurrentWeatherView_Preview_Container_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView_Preview_Container()
    }
}
