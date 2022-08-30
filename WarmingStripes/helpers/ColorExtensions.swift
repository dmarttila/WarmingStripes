//
//  ColorExtensions.swift
//  IntermittentFasting
//
//  Created by Doug Marttila on 9/15/21.
//

import SwiftUI

/*
 Usage: let appBgClr = Color(hex: 0xdfdcb9)
 */

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
    
}
