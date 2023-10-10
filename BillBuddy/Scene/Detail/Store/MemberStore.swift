//
//  MemberStore.swift
//  BillBuddy
//
//  Created by 김유진 on 9/30/23.
//

import Foundation
import FirebaseFirestore

class MemberStore: ObservableObject {
    @Published var members: [Member] = []
    
    var travelCalculationId: String
    var dbRef: CollectionReference
    
    init(travelCalculationId: String) {
        self.travelCalculationId = travelCalculationId
        self.dbRef = Firestore.firestore().collection("TravelCalculation").document(travelCalculationId).collection("Member")
    }
    
    func fetchAll() {
        dbRef.getDocuments { snapshot, error in
            if let snapshot {
                var tempMember: [Member] = []
                
                for doc in snapshot.documents {
//                    guard let newMember = try? Firestore.Decoder().decode(Member.self, from: doc.data()) else { continue }
//                    tempMember.append(newMember)
                    
                    let id: String = doc.documentID
                    let docData = doc.data()
                    
                    let name: String = docData["name"] as? String ?? ""
                    let advancePayment: Int = docData["advancePayment"] as? Int ?? 0
                    let payment: Int = docData["payment"] as? Int ?? 0
                    
                    let newMember = Member(id: id, name: name, advancePayment: advancePayment, payment: payment)
                    
                    tempMember.append(newMember)
                }
                
                DispatchQueue.main.async {
                    self.members = tempMember
                }
                
            }
        }
    }
    
    func addMember(newMember: Member) {
        
    }
    
    func editMember(editMember: Member) {
        
    }
    
    func findMemberById(memberId: String)->Member? {
        print(members)
        if let existMember = members.firstIndex(where: { m in
            m.id == memberId
        })
        {
            print(memberId, members[existMember])
            return members[existMember]
        }
        return nil
    }
    
    func findMembersByParticipants(participants: [Payment.Participant]) -> [Member] {
        var member: [Member] = []
        
        for p in participants {
            if let m = self.findMemberById(memberId: p.memberId)
            {
                member.append(m)
            }
        }
        
        return member
    }
}
