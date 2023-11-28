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
        Self.dateFormatter.dateFormat = "yyyy. MM. dd"
        
        return Self.dateFormatter.string(from: self)
    }

    var dateWeek: String {
        Self.dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        Self.dateFormatter.locale = Locale(identifier: "ko_KR")
        Self.dateFormatter.dateFormat = "MM.dd(eeeee)"
        
        return Self.dateFormatter.string(from: self)
    }
    
    var dateWeekYear: String {
        Self.dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        Self.dateFormatter.locale = Locale(identifier: "ko_KR")
        Self.dateFormatter.dateFormat = "YYYY년 MM월 dd일"
        
        return Self.dateFormatter.string(from: self)
    }
    
    var dateSelectorFormat: String {
        Self.dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        Self.dateFormatter.locale = Locale(identifier: "ko_KR")
        Self.dateFormatter.dateFormat = "YYYY. MM. dd HH:mm"
        
        return Self.dateFormatter.string(from: self)
    }
    
}
