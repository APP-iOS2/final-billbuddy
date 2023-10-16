//
//  Utills.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
    /// 2952E7
    static let myPrimary = Color(hex: "#2952E7")
    /// D84D50
    static let error = Color(hex: "#D84D50")
    /// 57B585
    static let positive = Color(hex: "#57B585")
    
    /// F7F7FA
    static let gray050 = Color(hex: "#F7F7FA")
    /// F0F0F5
    static let gray100 = Color(hex: "#F0F0F5")
    /// E8E8EE
    static let gray200 = Color(hex: "#E8E8EE")
    /// E1E1E8
    static let gray300 = Color(hex: "#E1E1E8")
    /// CDCED6
    static let gray400 = Color(hex: "#CDCED6")
    /// A9ABB8
    static let gray500 = Color(hex: "#A9ABB8")
    /// 858899
    static let gray600 = Color(hex: "#858899")
    /// 525463
    static let gray700 = Color(hex: "#525463")
    /// 3E404C
    static let gray800 = Color(hex: "#3E404C")
    /// 2B2D36
    static let gray900 = Color(hex: "#2B2D36")
    /// F5F6FE
    static let gray1000 = Color(hex: "F5F6FE")
    /// black / 252730
    static let systemBlack = Color(hex: "#252730")

}
