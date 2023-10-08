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
        
        let red = Double((rgb & 0xFF000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
    
    /// 2952E7
    static let primary = Color(hex: "#2952E7")
    /// D84D50
    static let error = Color(hex: "#D84D50")
    /// 57B585
    static let positive = Color(hex: "#57B585")
    
    /// gray-050
    /// F7F7FA
    static let systemGray01 = Color(hex: "#F7F7FA")
    /// gray-100 
    /// F0F0F5
    static let systemGray02 = Color(hex: "#F0F0F5")
    /// gray-200
    /// E8E8EE
    static let systemGray03 = Color(hex: "#E8E8EE")
    /// gray-300
    /// E1E1E8
    static let systemGray04 = Color(hex: "#E1E1E8")
    /// gray-400
    /// CDCED6
    static let systemGray05 = Color(hex: "#CDCED6")
    /// gray-500
    /// A9ABB8
    static let systemGray06 = Color(hex: "#A9ABB8")
    /// gray-600
    /// 858899
    static let systemGray07 = Color(hex: "#858899")
    /// gray-700
    /// 525463
    static let systemGray08 = Color(hex: "#525463")
    /// gray-800
    /// 3E404C
    static let systemGray09 = Color(hex: "#3E404C")
    /// gray-900
    /// 2B2D36
    static let systemGray10 = Color(hex: "#2B2D36")
    /// black / 252730
    static let systemBlack = Color(hex: "#252730")

}
