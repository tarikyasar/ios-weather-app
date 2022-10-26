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
                    WeatherReportContent(
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

struct WeatherReportContent: View {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
