//
//  MemberStore.swift
//  BillBuddy
//
//  Created by Ari on 10/6/23.
//

import Foundation

class TempMemberStore: ObservableObject {
    @Published var members: [TravelCalculation.Member]
    
    var travel: TravelCalculation
    
    init() {
        let sample = TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: Date.now.timeIntervalSince1970, endDate: Date.now.timeIntervalSince1970 + 1, updateContentDate: Date.now, members: [TravelCalculation.Member(name: "인원1", advancePayment: 200, payment: 0)])
        self.travel = sample
        self.members = sample.members
    }
    
    func addMember() {
        let newMemeber = TravelCalculation.Member(name: "인원1", advancePayment: 0, payment: 0)
        members.append(newMemeber)
        print(members.count)
    }
    
    func removeMember() {
        if !members.isEmpty {
            members.removeLast()
            print(members.count)
        }
    }
}
