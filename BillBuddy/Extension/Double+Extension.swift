//
//  Double+Extension.swift
//  BillBuddy
//
//  Created by 김유진 on 9/29/23.
//

import Foundation

extension Double {
    private static let defaultPreferredLanguage = "ko-kr"
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? Self.defaultPreferredLanguage)
        return formatter
    }()
    
    func toDate() -> Date {
        return Date(timeIntervalSince1970: self)
    }
    
    func toFormattedDate() -> String {
        let dateCreatedAt: Date = Date(timeIntervalSince1970: self)
        
        Self.dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        Self.dateFormatter.dateFormat = "YY년 MM월 dd일 HH시 mm분"
        
        return Self.dateFormatter.string(from: dateCreatedAt)
    }
}
