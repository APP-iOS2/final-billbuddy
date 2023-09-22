//
//  Model.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import Foundation
import FirebaseFirestoreSwift

/// 비밀번호는 Auth에서 불러와서 사용
/// strore에 저장
struct User: Identifiable, Codable {
    @DocumentID var id: String?
    
    var email: String
    var name: String
    var phoneNum: String
    var bankName: String // "국민"
    var bankAccountNum: String // "0290063094-24-1241"
    var isPremium: Bool
    var premiumDueDate: Double // 1970어쩌구저쩌구
    
    var formattedDate: String {
        let dateCreatedAt: Date = Date(timeIntervalSince1970: premiumDueDate)
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "MM/dd HH시 mm분"
        
        return dateFormatter.string(from: dateCreatedAt)
    }
}
