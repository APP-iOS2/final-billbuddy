//
//  MemberStore.swift
//  BillBuddy
//
//  Created by 김유진 on 9/30/23.
//

import Foundation
import FirebaseFirestore

//class MemberStore: ObservableObject {
//    @Published var members: [Member] = []
//    
//    var travelCalculationId: String
//    var dbRef: CollectionReference
//    
//    init(travelCalculationId: String) {
//        self.travelCalculationId = travelCalculationId
//        self.dbRef = Firestore.firestore().collection("TravelCalculation").document(travelCalculationId).collection("Member")
//    }
//    
//    func findMemberById(memberId: String)->Member? {
//        print(members)
//        if let existMember = members.firstIndex(where: { m in
//            m.id == memberId
//        })
//        {
//            print(memberId, members[existMember])
//            return members[existMember]
//        }
//        return nil
//    }
//    
//    func findMembersByParticipants(participants: [Payment.Participant]) -> [Member] {
//        var member: [Member] = []
//        
//        for p in participants {
//            if let m = self.findMemberById(memberId: p.memberId)
//            {
//                member.append(m)
//            }
//        }
//        
//        return member
//    }
//}
