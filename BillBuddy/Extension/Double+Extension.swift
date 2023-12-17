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
    
    func toFormattedMonthAndDate() -> String {
        let dateCreatedAt: Date = Date(timeIntervalSince1970: self)
        
        Self.dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        Self.dateFormatter.dateFormat = "MM.dd"
        
        return Self.dateFormatter.string(from: dateCreatedAt)
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
    
    func toDate() -> Date {
        return Date(timeIntervalSince1970: self)
    }
    
    // Date 연산
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
    
    func timeTo00_00_00() -> Double {
        var date = Date(timeIntervalSince1970: self)
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        date = calendar.date(from: dateComponents) ?? date
        return date.timeIntervalSince1970
    }
    
    func timeTo11_59_59() -> Double {
        var date = Date(timeIntervalSince1970: self)
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        dateComponents.hour = 23
        dateComponents.minute = 59
        dateComponents.second = 59
        date = calendar.date(from: dateComponents) ?? date
        return date.timeIntervalSince1970
    }
    
    func todayRange()->ClosedRange<Double> {
        let today_00_00_00 = timeTo00_00_00()
        let today_11_59_59 = timeTo11_59_59()
        
        return today_00_00_00...today_11_59_59
    }
    
    func convertGMT() -> Double {
        var date = Date(timeIntervalSince1970: self)
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        date = calendar.date(byAdding: .hour, value: 9, to: dateComponents.date ?? date) ?? date
        return date.timeIntervalSince1970
    }
}
