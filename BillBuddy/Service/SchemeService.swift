//
//  SchemeManager.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/27.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

/// 규칙
/// billbuddybuddy://invite?travelId=\(travelid),memberId=\(memberid)
enum URLSchemeBase: String {
    case scheme = "billbuddybuddy"
    case path = "path"
    case query = "query"
}

struct PushUrl {
    let scheme: String = "billbuddybuddy"
    let host: NotiType
    var querys: [String:String]
}

final class SchemeService: ObservableObject {
    @Published var url: URL? = nil
    @Published var isLoading = false
    @Published var componentedUrl: PushUrl? = nil
    
    var isUrlEmpty: Bool {
        return url == nil
    }
    
    static let shared: SchemeService = SchemeService()
    let dbRef = Firestore.firestore()
    
    private init() { }
    
    var travel: TravelCalculation = TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: [])
    
    /// 기본: openUrl 로 진입 시
    @MainActor
    func getUrl(url: URL) {
        self.url = url
        self.isLoading = true
        var push = PushUrl(host: .invite, querys: [:])
        if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true) {
            components.queryItems?.forEach {
                push.querys[$0.name] = $0.value
            }
        }
        print("push1 --> \(push)")
        self.componentedUrl = push
        print("push1 --> \(push)")
        joinAndFetchTravel()
    }
    
    /// 여행방 초대 알림선택 시
    @MainActor
    func getInviteNoti(_ noti: UserNotification) {
        let urlString = noti.contentId
        guard let encodeString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: encodeString) else { return }
        getUrl(url: url)
    }
    
    @MainActor
    func joinAndFetchTravel() {
        Task {
            self.isLoading = true
            guard let travelId = componentedUrl?.querys["travelId"] else { return }
            guard let memberId = componentedUrl?.querys["memberId"] else { return }
            
            do {
                let snapshotData = try await self.dbRef.collection("TravelCalculation").document(travelId).getDocument()
                
                var travel = try snapshotData.data(as: TravelCalculation.self)
                guard let user = UserService.shared.currentUser else { return }
                
                //                /// 현재 맴버에 자신이 포함되어있으면 return
                if travel.members.firstIndex(where: { $0.userId == user.id }) != nil {
                    self.travel = travel
                    removeUrl()
                    return
                }
                var member = TravelCalculation.Member(name: "", advancePayment: 0, payment: 0)
                if let index = travel.members.firstIndex(where: { $0.id == memberId }),
                   travel.members[index].userId == nil {
                    member = travel.members[index]
                }
                member.userId = AuthStore.shared.userUid
                member.name = user.name
                member.bankName = user.bankName
                member.bankAccountNum = user.bankAccountNum
                member.isInvited = true
                member.reciverToken = UserService.shared.reciverToken
                travel.updateContentDate = Date.now.timeIntervalSince1970
                if let index = travel.members.firstIndex(where: { $0.id == memberId }) {
                    travel.members[index] = member
                } else {
                    travel.members.append(member)
                }
                
                let userTravel = UserTravel(travelId: travelId)
                try dbRef.collection("TravelCalculation").document(travelId).setData(from: travel.self)
                try dbRef.collection("User").document(AuthStore.shared.userUid).collection("UserTravel").addDocument(from: userTravel)
                print("--> \(travel)")
                self.travel = travel
                self.isLoading = false
            } catch {
                removeUrl()
            }
        }
    }
    
    func removeUrl() {
        self.url = nil
        self.isLoading = false
        self.componentedUrl = nil
    }
}
