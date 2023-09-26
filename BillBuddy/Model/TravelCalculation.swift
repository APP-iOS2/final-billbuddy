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
    /// 총무id
    var managerId: String
    var startDate: Date
    var endDate: Date
    var updateContentDate: Date
}
