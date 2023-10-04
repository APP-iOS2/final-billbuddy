//
//  Date+Extension.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/25.
//

import Foundation

extension Date {
    
    private static let defaultPreferredLanguage = "ko-kr"
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? Self.defaultPreferredLanguage)
        return formatter
    }()
    
    var dateAndTime: String {
        Self.dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        Self.dateFormatter.dateFormat = "MM/dd HH시 mm분"
        
        return Self.dateFormatter.string(from: self)
    }
    
    var test: String {
        return "test"
    }
}
