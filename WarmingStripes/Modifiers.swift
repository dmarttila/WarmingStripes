//
//  Modifiers.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 8/13/22.
//

import SwiftUI

struct GrowingButtonNoBackground: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding([.top, .bottom], 6.5)
            .padding([.leading, .trailing], 9.0)
            .foregroundColor(.accentColor)
            .cornerRadius(5)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}