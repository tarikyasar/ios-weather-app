//
//  ContentView.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 20.10.2022.
//

import SwiftUI
import ios_neumorphism

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    var dateFormatter = ISO8601DateFormatter.init()
    @State var isDarkModeEnabled = false
    
    var body: some View {
        ZStack {
            Color.backgroundColor
            
            VStack {
                if (viewModel.dailyReport.isEmpty) {
                    ProgressView()
                } else {
                    Spacer()
                    
                    CurrentWeatherView(
                        isDarkModeEnabled: $isDarkModeEnabled,
                        dailyReport: viewModel.dailyReport[0]
                    )
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 25) {
                            ForEach(viewModel.dailyReport, id: \.self) { dailyReport in
                                
                                HourlyWeatherReportView(isDarkModeEnabled: $isDarkModeEnabled, dailyReport: dailyReport)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 50)
                    }
                    
                    Spacer()
                }
            }
            .background(Color.backgroundColor)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .onAppear {
                viewModel.fetchWeatherReport()
            }
        }
        .preferredColorScheme(.light)
        .background(Color.backgroundColor)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
