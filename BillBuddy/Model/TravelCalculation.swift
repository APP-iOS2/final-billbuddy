//
//  TravelCalculation.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import Foundation
import FirebaseFirestoreSwift

struct TravelCalculation: Identifiable, Codable {
    @DocumentID var id: String?
    
    /// 방 호스트 user id
    var hostId: String
    let createdDate: Double
    var renewalDate: Double // 보여줄 일이없어 굳이 format 안해줘도 될듯합니다.

    
    var formattedDate: String {
        let dateCreatedAt: Date = Date(timeIntervalSince1970: createdDate)
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "MM/dd HH시 mm분"
        
        return dateFormatter.string(from: dateCreatedAt)
    }
}
