//
//  ContentView.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 20.10.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    var dateFormatter = ISO8601DateFormatter.init()
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    Text("Latitude: \(viewModel.weatherReport.latitude)")
                    
                    Text("Latitude: \(viewModel.weatherReport.longitude)")
                    
                    if (viewModel.dailyReport.isEmpty) {
                        ProgressView()
                    } else {
                        List {
                            ForEach(viewModel.dailyReport, id: \.self) { dailyReport in
                                VStack {
                                    HStack {
                                        Text(dailyReport.time)
                                        
                                        Spacer()
                                        
                                        Text(dailyReport.humidity)
                                    }
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Text(dailyReport.temperature)
                                        
                                        Spacer()
                                        
                                        Text(dailyReport.windSpeed)
                                        
                                        Spacer()
                                        
                                        Text(dailyReport.weatherSymbolName)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Weather Report")
                .onAppear {
                    viewModel.fetchWeatherReport()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
