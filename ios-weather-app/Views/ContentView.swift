//
//  ContentView.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 20.10.2022.
//

import SwiftUI
import Combine
import AVFoundation

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @StateObject var deviceLocationService = DeviceLocationService.shared
    
    @State var tokens: Set<AnyCancellable> = []
    @State var isDarkModeEnabled = false
    @State var cityName: String = "-"
    @State var time: String = ""
    
    var dateFormatter = ISO8601DateFormatter.init()
    
    var body: some View {
        ZStack {
            Color.backgroundColor
            
            VStack {
                if (viewModel.dailyReport.isEmpty && deviceLocationService.isLocationAccessGranted == true) {
                    ProgressView()
                } else {
                    WeatherReportView(
                        isDarkModeEnabled: $isDarkModeEnabled,
                        isLocationAccessProvided: deviceLocationService.isLocationAccessGranted,
                        cityName: cityName,
                        time: time,
                        onRefresh: refresh,
                        dailyReports: viewModel.dailyReport
                    )
                }
            }
            .background(Color.backgroundColor)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .onAppear {
                time = getTime()
                observeCoordinateUpdates()
                observeDeniedLocationAccess()
                observeCityName()
                deviceLocationService.requestLocationUpdates()
            }
        }
        .background(Color.backgroundColor)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
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
