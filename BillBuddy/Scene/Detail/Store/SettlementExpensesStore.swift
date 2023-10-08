//
//  SettlementExpensesStore.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/6/23.
//

import Foundation

class SettlementExpensesStore: ObservableObject {
    @Published var settlementExpenses = SettlementExpenses()
    
    init() {
        for _ in 0..<2 {
            self.settlementExpenses.members.append(SettlementExpenses.MemberPayment())
        }
    }
    
    func setSettlementExpenses(payments: [Payment], members: [Member]) {
        settlementExpenses.totalExpenditure = payments.reduce(0, { $0 + $1.payment } )
        
        settlementExpenses.totalTransportation = payments.filter{ $0.type == .transportation }.reduce(0, { $0 + $1.payment } )
        settlementExpenses.totalAccommodation = payments.filter{ $0.type == .accommodation }.reduce(0, { $0 + $1.payment } )
        settlementExpenses.totalTourism = payments.filter{ $0.type == .tourism }.reduce(0, { $0 + $1.payment } )
        settlementExpenses.totalFood = payments.filter{ $0.type == .food }.reduce(0, { $0 + $1.payment } )
        settlementExpenses.totalEtc = payments.filter{ $0.type == .etc }.reduce(0, { $0 + $1.payment } )
        
        settlementExpenses.members = members.map { SettlementExpenses.MemberPayment(memberData: $0, 총참여한나온금액: 0, personaPayment: 0, advancePayment: $0.advancePayment) }
        
        for payment in payments {
            var personaPayment = settlementExpenses.totalExpenditure / payment.participants.count
            for participant in payment.participants {
                let index = members.firstIndex(where: { $0.id == participant.memberId } )
                settlementExpenses.members[index!].총참여한나온금액 += personaPayment
                settlementExpenses.members[index!].personaPayment += participant.payment
            }
        }
    }
    
    func addExpenses(payment: Payment) {
        var personaPayment = payment.payment / payment.participants.count
        
        settlementExpenses.totalExpenditure += payment.payment
        
        switch payment.type {
        case .transportation:
            settlementExpenses.totalTransportation += payment.payment
        case .accommodation:
            settlementExpenses.totalAccommodation += payment.payment
        case .tourism:
            settlementExpenses.totalTourism += payment.payment
        case .food:
            settlementExpenses.totalFood += payment.payment
        case .etc:
            settlementExpenses.totalEtc += payment.payment
        }
        
        for participant in payment.participants {
            let index = settlementExpenses.members.firstIndex { $0.memberData.id == participant.memberId }
            settlementExpenses.members[index!].총참여한나온금액 += personaPayment
            settlementExpenses.members[index!].personaPayment += participant.payment
        }
    }
    
    func removeExpenses(payment: Payment) {
        var personaPayment = payment.payment / payment.participants.count
        
        settlementExpenses.totalExpenditure -= payment.payment
        
        switch payment.type {
        case .transportation:
            settlementExpenses.totalTransportation -= payment.payment
        case .accommodation:
            settlementExpenses.totalAccommodation -= payment.payment
        case .tourism:
            settlementExpenses.totalTourism -= payment.payment
        case .food:
            settlementExpenses.totalFood -= payment.payment
        case .etc:
            settlementExpenses.totalEtc += payment.payment
        }
        
        for participant in payment.participants {
            let index = settlementExpenses.members.firstIndex { $0.memberData.id == participant.memberId }
            settlementExpenses.members[index!].총참여한나온금액 -= personaPayment
            settlementExpenses.members[index!].personaPayment -= participant.payment
        }
    }
    
    func modifyExpenses(payment before : Payment, payment modified : Payment) {
        removeExpenses(payment: before)
        addExpenses(payment: modified)
    }
    
}
