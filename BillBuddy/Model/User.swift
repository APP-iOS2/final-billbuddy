//
//  Model.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//  2023/09/27. 13:40

import Foundation
import FirebaseFirestoreSwift

/// 비밀번호는 Auth에서 불러와서 사용
/// strore에 저장
struct User: Identifiable, Codable {
    @DocumentID var id: String?
    
    var email: String
    var name: String
    var bankName: String
    var bankAccountNum: String
    var isPremium: Bool
    var premiumDueDate: Date
    var userImage: String?
    /// 알림 토큰
    var reciverToken: String
    
    var formattedDate: String {
        return premiumDueDate.dateAndTime
    }
}
