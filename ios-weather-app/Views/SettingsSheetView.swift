//
//  SettingsSheetView.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 27.10.2022.
//

import SwiftUI

struct SettingsSheetView: View {
    @Binding var temperatureUnitState: TemperatureUnit
    @Binding var themeState: Theme
    var onDismissRequest: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Settings")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                    .fontWeight(.medium)
                    .padding([.leading, .trailing, .top], 10)
                
                Spacer()
                
                Button(action: {
                    onDismissRequest()
                }, label: {
                    Image(systemName: "multiply")
                        .font(.system(size: 34))
                        .foregroundColor(.gray)
                        .padding([.trailing, .top], 10)
                })
            }
            .padding(.bottom, 20)
            
            Divider()
            
            HStack {
                Text("Temperature Unit")
                    .font(.system(size: 26))
                    .foregroundColor(.darkGray)
                    .fontWeight(.medium)
                
                Spacer()
                
                Menu {
                    Button {
                        temperatureUnitState = TemperatureUnit.fahrenheit
                    } label: {
                        Text("Fahrenheit")
                    }
                    
                    Button {
                        temperatureUnitState = TemperatureUnit.celsius
                    } label: {
                        Text("Celsius")
                    }
                } label: {
                    Text(temperatureUnitState.rawValue)
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .frame(width: 100)
                }
            }
            .padding(10)
            
//            Divider()
//            
//            HStack {
//                Text("Theme")
//                    .font(.system(size: 26))
//                    .foregroundColor(.darkGray)
//                    .fontWeight(.medium)
//                
//                Spacer()
//                
//                Menu {
//                    Button {
//                        themeState = Theme.dark
//                    } label: {
//                        Text(Theme.dark.rawValue)
//                    }
//                    
//                    Button {
//                        themeState = Theme.light
//                    } label: {
//                        Text(Theme.light.rawValue)
//                    }
//                } label: {
//                    Text(themeState.rawValue)
//                        .fontWeight(.medium)
//                        .font(.system(size: 20))
//                        .foregroundColor(.gray)
//                        .frame(width: 100)
//                }
//            }
//            .padding(10)
            
            Spacer()
        }
    }
}
