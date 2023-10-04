//
//  SampleMemeberStroe.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/3/23.
//

import Foundation

class SampleMemeberStore: ObservableObject {    
    @Published var members: [TravelCalculation.Member]
    @Published var isShowingAlert: Bool = false
    @Published var alertDescription: String = ""
    
    var travel: TravelCalculation
    
    init() {
        let sample = TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: Date.now.timeIntervalSince1970, endDate: Date.now.timeIntervalSince1970 + 1, updateContentDate: Date.now, members: [TravelCalculation.Member(name: "인원1", advancePayment: 200, payment: 0)])
        self.travel = sample
        self.members = sample.members
    }
    
    func saveMemeber() {
        Task {
            do {
                self.travel.updateContentDate = Date.now
                try await FirestoreService.shared.saveDocument(collection: .travel, documentId: self.travel.id ?? "", data: self.travel)
            } catch {
                self.alertDescription = "저장을 실패하였습니다."
                self.isShowingAlert = true
            }
        }
    }
    
    func addMember() {
        let newMemeber = TravelCalculation.Member(name: "인원\(members.count + 1)", advancePayment: 0, payment: 0)
        members.append(newMemeber)
    }
    
    func removeMember(_ index: IndexSet) {
        members.remove(atOffsets: index)
    }
    
    func getURL(userName: String) -> URL {
        let url = URL(string: "\(URLSchemeBase.scheme.rawValue).//travel?id=\(travel.id ?? "")/name=\(userName)")
        return url!
    }
    
    
}
