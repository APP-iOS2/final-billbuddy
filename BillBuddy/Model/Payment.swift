//
//  Payment.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import Foundation
import FirebaseFirestoreSwift

/// 결제 - 추가, 또는 수정 시 리얼타임 베이스에 갱신일 최신화
struct Payment: Identifiable, Codable {
    @DocumentID var id: String?
    
    var travelDate: String // "2023/7/4"
    
    var type: PaymentType // 분류
    var content: String // 내용
    var payment: Int // 금액
    var address: String // 주소
    var x : Double
    var y: Double
    var participants: [Participant]
    
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

enum PaymentType: String, Codable {
        case transportation // 교통
        case accommodation // 숙박
        case tourism // 관광
        case food // 식비
        case etc // 기타
}
