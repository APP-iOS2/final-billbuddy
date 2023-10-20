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
    
    func timeTo00_00_00() -> Double {
            return 86400 * floor(self / 86400)
        }

        func timeTo11_59_59() -> Double {
            return 86400 * ceil(self / 86400) - 1
        }
    
    func toFormattedYearandMonthandDay() -> String {
        let dateCreatedAt: Date = Date(timeIntervalSince1970: self)
        
        Self.dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        Self.dateFormatter.dateFormat = "YYYY.MM.dd"
        
        return Self.dateFormatter.string(from: dateCreatedAt)
    }
    
    func toFormattedDate() -> String {
        let dateCreatedAt: Date = Date(timeIntervalSince1970: self)
        
        Self.dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        Self.dateFormatter.dateFormat = "YY년 MM월 dd일 HH:mm"
        
        return Self.dateFormatter.string(from: dateCreatedAt)
    }
    
    func howManyDaysFromStartDate(startDate: Double)->Int {
        if self < startDate {
            return -1
        }
        let now = 86400 * floor(self / 86400)
        let start = 86400 * floor(startDate / 86400)
        
        let difference: Double = now - start
        let days = difference / 86400
        
        return Int(days) + 1
    }
    
    func todayRange()->ClosedRange<Double> {
        let today_00_00_00 = 86400 * floor(self / 86400)
        let today_11_59_59 = 86400 * ceil(self / 86400) - 1
        
        return today_00_00_00...today_11_59_59
    }
    
    func toFormattedChatDate() -> String {
        let dateCreatedAt: Date = Date(timeIntervalSince1970: self)
        let distanceHour = Calendar.current.dateComponents([.hour], from: dateCreatedAt, to: Date()).hour
        Self.dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        Self.dateFormatter.locale = Locale(identifier:"ko_KR")
        
        if distanceHour ?? 0 < 24 {
            Self.dateFormatter.dateFormat = "a h:mm"
            return Self.dateFormatter.string(from: dateCreatedAt)
        } else {
            Self.dateFormatter.dateFormat = "M월 d일"
            return Self.dateFormatter.string(from: dateCreatedAt)
        }
    }
}
