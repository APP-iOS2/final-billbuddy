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
    
    @Published var isEdited: Bool = false
    
    var travel: TravelCalculation
    
    init() {
        let sample = TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: Date.now.timeIntervalSince1970, endDate: Date.now.timeIntervalSince1970 + 1, updateContentDate: Date.now.timeIntervalSince1970, isPaymentSettled: false, members: [TravelCalculation.Member(name: "인원1", advancePayment: 200, payment: 0)])
        self.travel = sample
        self.members = sample.members
    }
    
    func saveMemeber() async {
        Task {
            do {
                self.travel.updateContentDate = Date.now.timeIntervalSince1970
                try await FirestoreService.shared.saveDocument(collection: .travel, documentId: self.travel.id, data: self.travel)
                
            } catch {
                self.alertDescription = "저장을 실패하였습니다."
                self.isShowingAlert = true
            }
        }
    }
    
    func addMember() {
        let newMemeber = TravelCalculation.Member(name: "인원\(members.count + 1)", advancePayment: 0, payment: 0)
        members.append(newMemeber)
        isEdited = true
        print(isEdited)
    }
    
    func removeMember(memberId: String) {
        guard let index = members.firstIndex(where: { $0.id == memberId }) else { return }
        guard members[index].userId != nil else { return }
        members.remove(at: index)
        isEdited = true
    }
    
    func getURL(userId: String) -> URL {
        let urlString = "\(URLSchemeBase.scheme.rawValue).//travel?id=\(travel.id)/userId=\(userId)"
        guard let encodeString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return URL(string: "실패!")! }
        guard let url = URL(string: encodeString) else { return URL(string: "실패!")! }
        
        return url
    }
    
    
}
