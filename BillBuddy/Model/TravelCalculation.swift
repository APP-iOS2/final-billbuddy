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
    let hostId: String
    var travelTitle: String
    /// 총무id
    var managerId: String
    var startDate: Double
    var endDate: Double
    var updateContentDate: Date
    var members: [Member]
    
    struct Member: Codable {
        var userId: String?
        var name: String
        /// 선금
        var advancePayment: Int
        /// 쓴비용 중간중간 + - << 추가 할지 말지 고민해야함.
        var payment: Int
    }
}
