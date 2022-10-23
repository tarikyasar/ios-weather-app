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
    @State var yOffSet: CGFloat = 0
    @State var refreshViewBackgroundColor = Color.gray
    
    var dateFormatter = ISO8601DateFormatter.init()
    
    var body: some View {
        ZStack {
            Color.backgroundColor
            
            VStack {
                if (viewModel.dailyReport.isEmpty) {
                    ProgressView()
                } else {
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
                                .frame(width: 250, height: 250)
                            
                            VStack {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 24))
                                    .foregroundColor(yOffSet >= 45 ? Color.black : Color.white)
                                    .rotationEffect(.degrees(-yOffSet*8), anchor: .center)
                                    .padding(.top, 5)
                                
                                Spacer()
                            }
                            .frame(width: 250, height: 250)
                        }
                        
                        CurrentWeatherView(
                            isDarkModeEnabled: $isDarkModeEnabled,
                            dailyReport: viewModel.dailyReport[0]
                        )
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .onChanged { value in
                                let verticalAmount = value.translation.height
                                if (verticalAmount >= 0 && verticalAmount <= 45) {
                                    yOffSet = verticalAmount
                                }
                                
                                refreshViewBackgroundColor = verticalAmount >= 45 ? Color.green : Color.gray
                            }
                            .onEnded { value in
                                yOffSet = 0
                                    
                                if (value.translation.height >= 45) {
                                    refresh()
                                }
                            }
                        )
                        .offset(y: yOffSet)
                    }
                    
                    
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
                time = getTime()
                
                observeCoordinateUpdates()
                observeDeniedLocationAccess()
                observeCityName()
                
                deviceLocationService.requestLocationUpdates()
            }
        }
        .preferredColorScheme(.light)
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
            .sink {
                print("Handle access denied event, possibly with an alert.")
            }
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
