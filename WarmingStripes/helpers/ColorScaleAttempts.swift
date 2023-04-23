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


import Foundation
import UIKit

// Fantastic explanation of how it works
// http://www.niwa.nu/2013/05/math-behind-colorspace-conversions-rgb-hsl/
fileprivate extension CGFloat {
    /// clamp the supplied value between a min and max
    /// - Parameter min: The min value
    /// - Parameter max: The max value
    func clamp(min: CGFloat, max: CGFloat) -> CGFloat {
        if self < min {
            return min
        } else if self > max {
            return max
        } else {
            return self
        }
    }

    /// If colour value is less than 1, add 1 to it. If temp colour value is greater than 1, substract 1 from it
    func convertToColourChannel() -> CGFloat {
        let min: CGFloat = 0
        let max: CGFloat = 1
        let modifier: CGFloat = 1
        if self < min {
            return self + modifier
        } else if self > max {
            return self - max
        } else {
            return self
        }
    }

    /// Formula to convert the calculated colour from colour multipliers
    /// - Parameter temp1: Temp variable one (calculated from luminosity)
    /// - Parameter temp2: Temp variable two (calcualted from temp1 and luminosity)
    func convertToRGB(temp1: CGFloat, temp2: CGFloat) -> CGFloat {
       if 6 * self < 1 {
           return temp2 + (temp1 - temp2) * 6 * self
       } else if 2 * self < 1 {
           return temp1
       } else if 3 * self < 2 {
           return temp2 + (temp1 - temp2) * (0.666 - self) * 6
       } else {
           return temp2
       }
   }
}

extension UIColor {
    /// Return a UIColor with adjusted luminosity, returns self if unable to convert
    /// - Parameter newLuminosity: New luminosity, between 0 and 1 (percentage)
    func withLuminosity(_ newLuminosity: CGFloat) -> UIColor {
        // 1 - Convert the RGB values to the range 0-1
        let coreColour = CIColor(color: self)
        var red = coreColour.red
        var green = coreColour.green
        var blue = coreColour.blue
        let alpha = coreColour.alpha

        // 1a - Clamp these colours between 0 and 1 (combat sRGB colour space)
        red = red.clamp(min: 0, max: 1)
        green = green.clamp(min: 0, max: 1)
        blue = blue.clamp(min: 0, max: 1)

        // 2 - Find the minimum and maximum values of R, G and B.
        guard let minRGB = [red, green, blue].min(), let maxRGB = [red, green, blue].max() else {
            return self
        }

        // 3 - Now calculate the Luminace value by adding the max and min values and divide by 2.
        var luminosity = (minRGB + maxRGB) / 2

        // 4 - The next step is to find the Saturation.
        // 4a - if min and max RGB are the same, we have 0 saturation
        var saturation: CGFloat = 0

        // 5 - Now we know that there is Saturation we need to do check the level of the Luminance in order to select the correct formula.
        //     If Luminance is smaller then 0.5, then Saturation = (max-min)/(max+min)
        //     If Luminance is bigger then 0.5. then Saturation = ( max-min)/(2.0-max-min)
        if luminosity <= 0.5 {
            saturation = (maxRGB - minRGB)/(maxRGB + minRGB)
        } else if luminosity > 0.5 {
            saturation = (maxRGB - minRGB)/(2.0 - maxRGB - minRGB)
        } else {
            // 0 if we are equal RGBs
        }

        // 6 - The Hue formula is depending on what RGB color channel is the max value. The three different formulas are:
        var hue: CGFloat = 0
        // 6a - If Red is max, then Hue = (G-B)/(max-min)
        if red == maxRGB {
            hue = (green - blue) / (maxRGB - minRGB)
        }
        // 6b - If Green is max, then Hue = 2.0 + (B-R)/(max-min)
        else if green == maxRGB {
            hue = 2.0 + ((blue - red) / (maxRGB - minRGB))
        }
        // 6c - If Blue is max, then Hue = 4.0 + (R-G)/(max-min)
        else if blue == maxRGB {
            hue = 4.0 + ((red - green) / (maxRGB - minRGB))
        }

        // 7 - The Hue value you get needs to be multiplied by 60 to convert it to degrees on the color circle
        //     If Hue becomes negative you need to add 360 to, because a circle has 360 degrees.
        if hue < 0 {
            hue += 360
        } else {
            hue *= 60
        }

        // we want to convert the luminosity. So we will.
        luminosity = newLuminosity

        // Now we need to convert back to RGB

        // 1 - If there is no Saturation it means that it’s a shade of grey. So in that case we just need to convert the Luminance and set R,G and B to that level.
        if saturation == 0 {
            return UIColor(red: 1.0 * luminosity, green: 1.0 * luminosity, blue: 1.0 * luminosity, alpha: alpha)
        }

        // 2 - If Luminance is smaller then 0.5 (50%) then temporary_1 = Luminance x (1.0+Saturation)
        //     If Luminance is equal or larger then 0.5 (50%) then temporary_1 = Luminance + Saturation – Luminance x Saturation
        var temporaryVariableOne: CGFloat = 0
        if luminosity < 0.5 {
            temporaryVariableOne = luminosity * (1 + saturation)
        } else {
            temporaryVariableOne = luminosity + saturation - luminosity * saturation
        }

        // 3 - Final calculated temporary variable
        let temporaryVariableTwo = 2 * luminosity - temporaryVariableOne

        // 4 - The next step is to convert the 360 degrees in a circle to 1 by dividing the angle by 360
        let convertedHue = hue / 360

        // 5 - Now we need a temporary variable for each colour channel
        let tempRed = (convertedHue + 0.333).convertToColourChannel()
        let tempGreen = convertedHue.convertToColourChannel()
        let tempBlue = (convertedHue - 0.333).convertToColourChannel()

        // 6 we must run up to 3 tests to select the correct formula for each colour channel, converting to RGB
        let newRed = tempRed.convertToRGB(temp1: temporaryVariableOne, temp2: temporaryVariableTwo)
        let newGreen = tempGreen.convertToRGB(temp1: temporaryVariableOne, temp2: temporaryVariableTwo)
        let newBlue = tempBlue.convertToRGB(temp1: temporaryVariableOne, temp2: temporaryVariableTwo)

        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
    }
}
