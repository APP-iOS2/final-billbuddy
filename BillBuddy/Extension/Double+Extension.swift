//
//  Double+Extension.swift
//  BillBuddy
//
//  Created by 김유진 on 9/29/23.
//

import Foundation

extension Double {
    func toDate() -> Date {
        return Date(timeIntervalSince1970: self)
    }
    
    func toFormattedDate() -> String {
        let dateCreatedAt: Date = Date(timeIntervalSince1970: self)
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "YY년 MM월 dd일 HH시 mm분"
        
        return dateFormatter.string(from: dateCreatedAt)

    }
}
