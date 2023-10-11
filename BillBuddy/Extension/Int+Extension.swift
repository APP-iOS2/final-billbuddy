//
//  Int+Extension.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/8/23.
//

import Foundation

extension Int {
    private static let numberFomatter = NumberFormatter()
    
    var wonAndDecimal: String {
        Self.numberFomatter.numberStyle = .decimal
        let famattedNumber = Self.numberFomatter.string(from: self as NSNumber) ?? "0"
        
        return "₩" + famattedNumber
    }
}
