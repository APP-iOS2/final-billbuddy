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

struct PushType {
    let scheme: String = "billbuddybuddy"
    let host: NotiType
    var querys: [String:String]
}

final class InvitTravelService: ObservableObject {
    @Published var isLoading = false
    
    static let shared: InvitTravelService = InvitTravelService()
    private init() { }

    let dbRef = Firestore.firestore()
    var componentedUrl: PushType? = nil
    
    /// DeepLink - openUrl 로 진입 시
    @MainActor
    func transformUrl(url: URL) {
        self.isLoading = true
        var push = PushType(host: .invite, querys: [:])
        if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true) {
            components.queryItems?.forEach {
                push.querys[$0.name] = $0.value
            }
        }
        self.componentedUrl = push
    }
    
    /// Notification - 여행방 초대 알림으로 진입 시
    @MainActor
    func getInviteNoti(_ noti: UserNotification) {
        let urlString = noti.contentId
        guard let encodeString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: encodeString) else { return }
        transformUrl(url: url)
    }
    
    /// 여행 입장 및 fetch
    @MainActor
    func joinAndFetchTravel(onComplete: @escaping (TravelCalculation) -> ()) {
        Task {
            guard let travelId = componentedUrl?.querys["travelId"] else { return }
            guard let memberId = componentedUrl?.querys["memberId"] else { return }

            do {
                guard let user = UserService.shared.currentUser else { return }
                
                let snapshotData = try await self.dbRef.collection("TravelCalculation").document(travelId).getDocument()
                
                var travel = try snapshotData.data(as: TravelCalculation.self)

                // 현재 맴버에 자신이 포함되어있으면 return
                if travel.members.firstIndex(where: { $0.userId == user.id }) != nil {
                    removeUrl()
                    return
                }
                
                var members = travel.members
                var newMember = TravelCalculation.Member(name: "", advancePayment: 0, payment: 0)
                
                //
                if let index = members.firstIndex(where: { $0.id == memberId }),
                   travel.members[index].userId == nil {
                    newMember = members[index]
                }
                
                //
                
                newMember.userId = AuthStore.shared.userUid
                newMember.name = user.name
                newMember.bankName = user.bankName
                newMember.bankAccountNum = user.bankAccountNum
                newMember.isInvited = true
                newMember.reciverToken = UserService.shared.reciverToken

                if let index = travel.members.firstIndex(where: { $0.id == memberId }) {
                    members[index] = newMember
                } else {
                    members.append(newMember)
                }
                
                let userTravel = UserTravel(travelId: travelId)
                
//                try await dbRef.collection(StoreCollection.travel.path)
//                    .document(travelId)
//                    .setData([
//                        "members" : members
//                    ], merge: true)
                
                travel.members = members
                
                do {
                    try await dbRef.collection(StoreCollection.travel.path)
                        .document(travelId)
                        .setData(from: travel.self)
                } catch {
                    print("invite error1 - \(error)")
                }
                
                
                do {
                    try dbRef.collection(StoreCollection.user.path)
                        .document(AuthStore.shared.userUid).collection(StoreCollection.userTravel.path)
                        .addDocument(from: userTravel)
                    
                } catch {
                    print("invite error2 - \(error)")
                }
                self.isLoading = false
                onComplete(travel)
            } catch {
                print("invite error - \(error)")
                removeUrl()
            }
        }
    }
    
    func removeUrl() {
        self.isLoading = false
        self.componentedUrl = nil
    }
}
