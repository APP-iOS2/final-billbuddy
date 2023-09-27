//
//  UserTravel.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/25.
//

import Foundation
import FirebaseFirestoreSwift


///1. 개설을 했을 경우 -> UserTravel 에 저장
///2. 초대를 받아서 들어갔을경우 -> UserTravel 에 저장
struct UserTravel: Identifiable, Codable {
    @DocumentID var id: String?
    var travelId: String
    var travelName: String
    // ~~~~~~~ 필요한 아이템들 넣으면 됨.
}
