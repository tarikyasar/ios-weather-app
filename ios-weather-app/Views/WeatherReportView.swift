//
//  WeatherReportView.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 26.10.2022.
//

import SwiftUI

struct WeatherReportView: View {
    @State var refreshViewBackgroundColor = Color.gray
    @State var yOffSet: CGFloat = 0
    
    @Binding var isDarkModeEnabled: Bool
    var isLocationAccessProvided: Bool
    
    var cityName: String
    var time: String
    var onRefresh: () -> Void
    var dailyReports: [HourlyWeatherReport]
    
    var body: some View {
        if (isLocationAccessProvided) {
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
            
            ZStack {
                // Refresh View
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
                
                CurrentWeatherView(
                    isDarkModeEnabled: $isDarkModeEnabled,
                    dailyReport: dailyReports[0]
                )
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
            .padding(.bottom, 40)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 25) {
                    ForEach(dailyReports, id: \.self) { dailyReport in
                        HourlyWeatherReportView(
                            isDarkModeEnabled: $isDarkModeEnabled,
                            dailyReport: dailyReport
                        )
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 50)
            }
            
            Spacer()
        } else {
            VStack {
                Image(systemName: "location.circle")
                    .foregroundColor(.gray)
                    .font(.system(size: 60))
                
                Text("Allow location access to view weather information.")
                    .padding()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .font(.system(size: 20))
            }
        }
    }
}
