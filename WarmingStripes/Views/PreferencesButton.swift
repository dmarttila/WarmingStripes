//
//  PreferencesButton.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 4/9/23.
//

import SwiftUI

struct PreferencesButton: View {
    @Binding var showPreferences: Bool
    
    private let lightBlue = Color(hex: 0x00BCD4)
    private let innerCircleSize: CGFloat = 30
    
    var body: some View {
        Button {
            showPreferences.toggle()
        } label: {
            ZStack {
                Circle()
                    .fill(lightBlue)
                    .frame(width: 58, height: 58)
                Circle()
                    .fill(.white)
                    .frame(width: innerCircleSize - 2, height: innerCircleSize - 2)
                Image(systemName: "line.3.horizontal.circle.fill")
                    .resizable()
                    .foregroundColor(lightBlue)
                    .frame(width: innerCircleSize, height: innerCircleSize)
            }
        }
    }
}

