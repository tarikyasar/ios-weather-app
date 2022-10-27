//
//  SettingsButton.swift
//  ios-weather-app
//
//  Created by Tarik Yasar on 27.10.2022.
//

import SwiftUI
import ios_neumorphism

struct SettingsButton: View {
    @Binding var showSettingsSheet: Bool
    var body: some View {
        ZStack {
            if (showSettingsSheet) {
                NeumorphicPressedSurface(
                    surfaceShape: Circle(),
                    isDarkModeEnabled: false,
                    width: 50,
                    height: 50
                )
            } else {
                NeumorphicSurface(
                    surfaceShape: Circle(),
                    isDarkModeEnabled: false,
                    width: 50,
                    height: 50
                )
            }
            
            Image(systemName: "gear")
                .foregroundColor(.gray)
                .font(.system(size: 24))
                .onTapGesture {
                    showSettingsSheet.toggle()
                }
        }
    }
}
