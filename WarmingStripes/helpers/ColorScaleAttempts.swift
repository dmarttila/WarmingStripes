//
//  ColorScaleAttempts.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 4/21/23.
//

import SwiftUI


var colorAgain: Color {
    let color = UIColor.blue // the color you want to adjust the brightness of
    let brightnessOffset: CGFloat = 0 // the amount you want to adjust the brightness by

    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0

    // Get the hue, saturation, brightness, and alpha components of the original color
    color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

    // Adjust the brightness component by adding the offset
    brightness = max(min(brightness + brightnessOffset, 1.0), 0.0)

    // Create a new color with the adjusted brightness
    let newColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)

    return Color(newColor)
}

var color2: Color {
    let anomaly: Double = 0
//        if anomaly > 0 {
//            let val = 1 - anomaly/TemperatureAnomaly.maxAnomaly
//            return Color(red: 1, green: val, blue: val)
//        }
//        let val = 1 - anomaly/TemperatureAnomaly.minAnomaly
//        return Color(red: val, green: val, blue: 1)
    
    var value: Double
   
    let myRed = Color(hex: 0x67090D)
    let myBlue = Color(hex: 0x0A2F6B)
    if anomaly > 0 {
//            value = anomaly/TemperatureAnomaly.maxAnomaly
        let color1 = UIColor.white
        let color2 = UIColor(myRed)
        let color = colorForValue(value: Float(anomaly), color1: color1, color2: color2)
        return Color(color)
        
    } else {
        let color1 = UIColor.white
        let color2 = UIColor(myBlue)
        let color = colorForValue(value: Float(anomaly * -1), color1: color1, color2: color2)
        return Color(color)
//            value = anomaly/TemperatureAnomaly.minAnomaly
    }
//        let diff = TemperatureAnomaly.maxAnomaly - TemperatureAnomaly.minAnomaly
//        value = anomaly/diff        
//        value = -1
//        value = 0//anoma
//        value = (value + 1) / 2
//        value = .5
//        print(anomaly)
//        let color1 = UIColor.blue
//        let color2 = UIColor.white
//        let color3 = UIColor.red
////        let value = 0.5
//        let color = colorForValue(value: Float(anomaly), color1: color1, color2: color2)
//        //let color = colorForValue(value: Float(value), color1: color1, color2: color2)
//        return Color(color)
}

func colorForValue(value: Float, color1: UIColor, color2: UIColor) -> UIColor {
    let clampedValue = max(-1, min(value, 1)) // clamp the value to the range of -1 to 1
    let red1 = CGFloat(CIColor(color: color1).red)
    let green1 = CGFloat(CIColor(color: color1).green)
    let blue1 = CGFloat(CIColor(color: color1).blue)
    let alpha1 = CGFloat(CIColor(color: color1).alpha)
    let red2 = CGFloat(CIColor(color: color2).red)
    let green2 = CGFloat(CIColor(color: color2).green)
    let blue2 = CGFloat(CIColor(color: color2).blue)
    let alpha2 = CGFloat(CIColor(color: color2).alpha)
    let red = (1 - CGFloat(clampedValue)) * red1 + CGFloat(clampedValue) * red2
    let green = (1 - CGFloat(clampedValue)) * green1 + CGFloat(clampedValue) * green2
    let blue = (1 - CGFloat(clampedValue)) * blue1 + CGFloat(clampedValue) * blue2
    let alpha = (1 - CGFloat(clampedValue)) * alpha1 + CGFloat(clampedValue) * alpha2
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}

