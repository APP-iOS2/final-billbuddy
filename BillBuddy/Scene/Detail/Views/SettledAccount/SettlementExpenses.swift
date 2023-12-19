//
//  SettlementExpenses.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/6/23.
//

import Foundation

struct SettlementExpenses {
    var totalExpenditure: Int = 0

    /// 총교통비
    var totalTransportation: Int = 0
    /// 총숙박비
    var totalAccommodation: Int = 0
    /// 총관광비
    var totalTourism: Int = 0
    /// 총식비
    var totalFood: Int = 0
    /// 총기타비용
    var totalEtc: Int = 0

    var members: [MemberPayment] = []

    struct MemberPayment {
        var memberData: TravelCalculation.Member = TravelCalculation.Member(name: "name", advancePayment: 0, payment: 0)
        /// 총참여한 나온 금액
        var totalParticipationAmount: Int = 0
        /// 총개인 결제 금액
        var personaPayment: Int = 0
        /// 선금
        var advancePayment: Int = 0
        
        /// 최종 n/1 금액
        ///  - 시 받아야할 금액 / + 시 내야할 금액
        var lastDividedAmount: Int {
            totalParticipationAmount - personaPayment - advancePayment
        }
    }
}
