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

struct PushData {
    let scheme: String = "billbuddybuddy"
    let host: NotiType
    var querys: [String:String]
}

final class InvitTravelService: ObservableObject {
    @Published var isLoading = false
    @Published var isShowingAlert = false
    
    static let shared: InvitTravelService = InvitTravelService()
    private init() { }

    private let dbRef = Firestore.firestore()
    private var pushData: PushData? = nil
    
    private func transformUrl(url: URL) -> PushData {
        var push = PushData(host: .invite, querys: [:])
        if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true) {
            components.queryItems?.forEach {
                push.querys[$0.name] = $0.value
            }
        }
        return push
    }
    
    /// DeepLink - openUrl 로 진입 시
    @MainActor
    func getInviteURL(_ url: URL) {
        self.isLoading = true
        self.pushData = transformUrl(url: url)
    }
    
    /// Notification - 여행방 초대 알림으로 진입 시
    @MainActor
    func getInviteNoti(_ noti: UserNotification) {
        let urlString = noti.contentId
        guard let encodeString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: encodeString) else { return }
        self.isLoading = true
        self.pushData = transformUrl(url: url)
        pushData?.querys["notiId"] = noti.id!
    }
    
    func denialInviteNoti(_ noti: UserNotification) {
        let urlString = noti.contentId
        guard let encodeString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: encodeString) else { return }
        let push = transformUrl(url: url)
        changeMemberInvitingBoolean(push)
        removeNoti(noti.id)
    }
    
    private func removeNoti(_ notiId: String?) {
        guard let notiId = notiId else { return }
        dbRef.collection(StoreCollection.user.path).document(AuthStore.shared.userUid).collection(StoreCollection.notification.path).document(notiId).delete()
    }
    
    private func changeMemberInvitingBoolean(_ push: PushData) {
        Task {
            guard let travelId = push.querys["travelId"] else { return }
            let memberId = push.querys["memberId"]
            do {
                let snapshotData = try await self.dbRef.collection("TravelCalculation").document(travelId).getDocument()
                var travel = try snapshotData.data(as: TravelCalculation.self)
                
                guard let index = travel.members.firstIndex(where: { $0.id == memberId }) else { return }
                travel.members[index].isInvited = false
                
                try dbRef.collection(StoreCollection.travel.path)
                    .document(travelId)
                    .setData(from: travel.self)
                
            } catch {
                print("false change Member InvitingBoolean")
            }
        }
    }
    
    /// 여행 입장 및 fetch
    @MainActor
    func joinAndFetchTravel(onComplete: @escaping (TravelCalculation) -> ()) {
        Task {
            guard let travelId = pushData?.querys["travelId"] else { return }
            guard let memberId = pushData?.querys["memberId"] else { return }
            
            do {
                guard let user = UserService.shared.currentUser else { return }
                
                let snapshotData = try await self.dbRef.collection(StoreCollection.travel.path).document(travelId).getDocument()
                
                var travel = try snapshotData.data(as: TravelCalculation.self)
                
                
                // 현재 맴버에 자신이 포함되어있으면 return
                if travel.members.firstIndex(where: { $0.userId == user.id }) != nil {
                    isShowingAlert = true
                    guard let notiId = pushData?.querys["notiId"] else { return }
                    deleteNotification()
                    return
                }
                
                // id와 매칭되는 맴버가 없을 시 return
                guard let index = travel.members.firstIndex(where: { $0.id == memberId }) else {
                    isShowingAlert = true
                    deleteNotification()
                    return
                }
                
                // 초대중이 아닌경우 return 후 alert
                if travel.members[index].isInvited == false {
                    isShowingAlert = true
                    deleteNotification()
                    return
                }
                
                
                var members = travel.members
                var newMember = members[index]
                
                newMember.userId = AuthStore.shared.userUid
                newMember.name = user.name
                newMember.bankName = user.bankName
                newMember.bankAccountNum = user.bankAccountNum
                newMember.isInvited = true
                newMember.reciverToken = UserService.shared.reciverToken
                newMember.userImage = user.userImage ?? ""
                
                members[index] = newMember
                
                let userTravel = UserTravel(travelId: travelId)
                
                travel.members = members
                
                do {
                    try dbRef.collection(StoreCollection.travel.path)
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
                removePushData()
            }
        }
    }
    
    func removePushData() {
        self.isShowingAlert = false
        self.isLoading = false
        self.pushData = nil
    }
    
    func deleteNotification() {
        guard let notiId = pushData?.querys["notiId"] else { return }
        dbRef.collection(StoreCollection.user.path)
            .document(AuthStore.shared.userUid)
            .collection(StoreCollection.notification.path)
            .document(notiId)
    }
}
