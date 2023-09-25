//
//  UserTravel.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/25.
//

import Foundation
import FirebaseFirestoreSwift

struct UserTravel: Identifiable, Codable {
    @DocumentID var id: String?
    var travelId: String
    var travelName: String
    // ~~~~~~~ 필요한 아이템들 넣으면 됨.
}
