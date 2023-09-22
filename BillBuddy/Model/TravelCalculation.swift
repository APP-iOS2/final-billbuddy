//
//  TravelCalculation.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import Foundation
import FirebaseFirestoreSwift

struct TravelCalculation {
    @DocumentID var id: String?
    
    /// 방 호스트 user id
    var hostId: String
    let createdDate: Double
    
    var formattedDate: String {
        let dateCreatedAt: Date = Date(timeIntervalSince1970: createdDate)
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "MM/dd HH시 mm분"
        
        return dateFormatter.string(from: dateCreatedAt)
    }
}

struct Member: Identifiable, Codable {
    @DocumentID var id: String?
    var memberId: String? //nil이면 user가 들어와있지않은 임시 맴버
    var name: String
    var deposit: Int
}
