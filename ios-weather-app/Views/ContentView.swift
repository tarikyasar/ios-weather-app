//
//  ContentView.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 20.10.2022.
//

import SwiftUI
import Combine
import AVFoundation
import ios_neumorphism

struct ContentView: View {
    @AppStorage("tempUnit") var temperatureUnit: TemperatureUnit = TemperatureUnit.celsius
    @AppStorage("theme") var theme: Theme = Theme.light
    
    @StateObject var viewModel = ViewModel()
    @StateObject var deviceLocationService = DeviceLocationService.shared
    
    @State var tokens: Set<AnyCancellable> = []
    @State var cityName: String = "-"
    @State var time: String = ""
    @State var showSettingsSheet: Bool = false
    @State var temperatureUnitState: TemperatureUnit = TemperatureUnit.celsius
    @State var themeState: Theme = Theme.light
    
    var dateFormatter = ISO8601DateFormatter.init()
    
    var body: some View {
        VStack {
            if (viewModel.dailyReport.isEmpty && deviceLocationService.isLocationAccessGranted == true) {
                ProgressView()
                    .background(Color.backgroundColor)
            } else {
                VStack {
                    if (deviceLocationService.isLocationAccessGranted) {
                        HStack {
                            Spacer()
                            
                            SettingsButton(showSettingsSheet: $showSettingsSheet)
                                .padding(.trailing, 10)
                                .sheet(
                                    isPresented: $showSettingsSheet,
                                    onDismiss: {
                                        temperatureUnit = temperatureUnitState
                                    }
                                ) {
                                    ZStack {
                                        Color.backgroundColor
                                        
                                        SettingsSheetView(
                                            temperatureUnitState: $temperatureUnitState,
                                            themeState: $theme,
                                            onDismissRequest: {
                                                showSettingsSheet.toggle()
                                            }
                                        )
                                        
                                    }
                                    .background(Color.backgroundColor)
                                    .presentationDetents([.medium])
                                }
                        }
                        
                        WeatherReportView(
                            isDarkModeEnabled: .constant(themeState == Theme.dark),
                            cityName: cityName,
                            time: time,
                            onRefresh: refresh,
                            dailyReports: viewModel.dailyReport,
                            temperatureUnit: temperatureUnit,
                            weatherReport:viewModel.weatherReport
                        )
                    } else {
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
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("BackgroundColor"))
        .onAppear {
            temperatureUnitState = temperatureUnit
            themeState = theme
            
            time = getTime()
            observeCoordinateUpdates()
            observeDeniedLocationAccess()
            observeCityName()
            deviceLocationService.requestLocationUpdates()
        }
        .preferredColorScheme(theme == Theme.dark ? .dark : .light)
    }
    
    func refresh() {
        AudioServicesPlaySystemSound(1123)
        
        time = getTime()
        observeCoordinateUpdates()
        observeDeniedLocationAccess()
        observeCityName()
    }
    
    func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: Date())
    }
    
    func observeCoordinateUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Handle \(completion) for error and finished subscription.")
            } receiveValue: { coordinates in
                viewModel.fetchWeatherReport(latitude: coordinates.latitude, longitude: coordinates.longitude)
            }
            .store(in: &tokens)
    }
    
    func observeDeniedLocationAccess() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {}
            .store(in: &tokens)
    }
    
    func observeCityName() {
        deviceLocationService.cityNamePublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Handle \(completion) for error and finished subscription.")
            } receiveValue: { cityName in
                self.cityName = cityName
            }
            .store(in: &tokens)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
