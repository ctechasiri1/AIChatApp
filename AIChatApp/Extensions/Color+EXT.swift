//
//  Color+EXT.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/1/26.
//

import Foundation
import SwiftUI

extension Color {
    
    /// Creates a Color from a hex string, e.g. "#FF5733", "FF5733", "#F53", or with alpha "#FF5733AA"
    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        let red, green, blue, alpha: Double

        switch hexString.count {
        case 3: // RGB (12-bit)
            red = Double((rgbValue >> 8) & 0xF) / 15.0
            green = Double((rgbValue >> 4) & 0xF) / 15.0
            blue = Double(rgbValue & 0xF) / 15.0
            alpha = 1.0
        case 6: // RGB (24-bit)
            red = Double((rgbValue >> 16) & 0xFF) / 255.0
            green = Double((rgbValue >> 8) & 0xFF) / 255.0
            blue = Double(rgbValue & 0xFF) / 255.0
            alpha = 1.0
        case 8: // RGBA (32-bit)
            red = Double((rgbValue >> 24) & 0xFF) / 255.0
            green = Double((rgbValue >> 16) & 0xFF) / 255.0
            blue = Double((rgbValue >> 8) & 0xFF) / 255.0
            alpha = Double(rgbValue & 0xFF) / 255.0
        default:
            red = 0
            green = 0
            blue = 0
            alpha = 1.0
        }

        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }

    /// Converts the Color to a hex string, e.g. "#FF5733" or "#FF5733AA" if includeAlpha is true
    func toHex(includeAlpha: Bool = false) -> String {
        let uiColor = UIColor(self)

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let rInt = Int(round(red * 255))
        let gInt = Int(round(green * 255))
        let bInt = Int(round(blue * 255))
        let aInt = Int(round(alpha * 255))

        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", rInt, gInt, bInt, aInt)
        } else {
            return String(format: "#%02X%02X%02X", rInt, gInt, bInt)
        }
    }
}
