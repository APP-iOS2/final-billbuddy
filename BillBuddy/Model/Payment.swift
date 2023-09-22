//
//  Payment.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Payment: Identifiable, Codable {
    @DocumentID var id: String?
    var type: String // 분류
    var content: String // 내용
    var payment: Int // 금액
    var address: String // 주소
    var x : Double
    var y: Double
    
    var paymentDate: Double = Date().timeIntervalSince1970 // 지출날짜
    
    var formattedDate: String {
        let dateCreatedAt: Date = Date(timeIntervalSince1970: paymentDate)
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "MM/dd HH시 mm분"
        
        return dateFormatter.string(from: dateCreatedAt)
    }
}

struct Participant: Codable {
    var memberId: String
    var payment: Int
}
