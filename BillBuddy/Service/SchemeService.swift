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
    
    static let shared: SchemeService = SchemeService()
    let dbRef = Firestore.firestore()
    
    private init() { }
    
    var travel: TravelCalculation = TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: [])
    
    var isEmptyUrl: Bool {
        return url == nil
    }
    
    /// 기본: openUrl 로 진입 시
    func getUrl(url: URL) {
        self.url = url
        var push = PushUrl(host: .invite, querys: [:])
        if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true) {
            components.queryItems?.forEach {
                push.querys[$0.name] = $0.value
            }
        }
        self.componentedUrl = push
    }
    
    /// 여행방 초대 알림선택 시
    func getInviteNoti(_ noti: UserNotification) {
        let urlString = noti.contentId
        guard let encodeString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: encodeString) else { return }
        getUrl(url: url)
    }
    
    func joinAndFetchTravel() {
        Task {
            self.isLoading = true
            guard let travelId = componentedUrl?.querys["travelId"] else { return }
            guard let memberId = componentedUrl?.querys["memberId"] else { return }

            do {
                let snapshotData = try await self.dbRef.collection("TravelCalculation").document(travelId).getDocument()
                var travel = try snapshotData.data(as: TravelCalculation.self)
                guard let index = travel.members.firstIndex(where: { $0.id == memberId }) else { return }
                guard let user = UserService.shared.currentUser else { return }
                var member = travel.members[index]
                member.userId = AuthStore.shared.userUid
                member.name = user.name
                member.bankName = user.bankName
                member.bankAccountNum = user.bankAccountNum
                member.isInvited = true
                travel.updateContentDate = Date.now.timeIntervalSince1970
                travel.members[index] = member
                
                let userTravel = UserTravel(travelId: travelId)
                try dbRef.collection("User").document(AuthStore.shared.userUid).collection("UserTravel").addDocument(from: userTravel)
                try dbRef.collection("TravelCalculation").document(travelId).setData(from: travel)
                self.travel = travel
                self.isLoading = false

            } catch {
                print("제발 제발 제발 제발 제발 제발 제발 ")
            }
        }
    }
    
    func removeUrl() {
        self.url = nil
        self.isLoading = false
        self.componentedUrl = nil
    }
}
