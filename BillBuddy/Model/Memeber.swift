//
//  Memeber.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/24.
//

import Foundation
import FirebaseFirestoreSwift

/// 여행에 초대돼서 들어온 user - 호스트도 포함
struct Member: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String? //uid / nil이면 user가 들어와있지않은 임시 맴버
    var name: String
    var advancePayment: Int // 선금
    var payment: Int // 쓴비용 중간중간 + - << 추가 할지 말지 고민해야함.
}
