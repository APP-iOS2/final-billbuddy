//
//  UserTravel.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/25.
//  2023/09/27. 13:40

import Foundation
import FirebaseFirestoreSwift


struct UserTravel: Identifiable, Codable {
    @DocumentID var id: String?
    var travelId: String
    var travelName: String
//    var createdDate: Date
    var startDate: Double
    var endDate: Double
    var isPaymentSettled: Bool = false
    // ~~~~~~~ 필요한 아이템들 넣으면 됨.
}
