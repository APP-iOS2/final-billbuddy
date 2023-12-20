//
//  NotificationStore.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/20/23.
//

import Foundation
import FirebaseFirestore

final class NotificationStore: ObservableObject {
    
    static let shared = NotificationStore()
    
    enum NotificationReadState {
        case didRead
        case unRead
    }
    
    /// fetch해온 안읽은 notifications
    @Published var notifications: [UserNotification] = []
    /// 읽은 notifications (파이어 베이스에서는 삭제)
    @Published var readedNotifications: [UserNotification] = []
    var hasUnReadNoti: Bool {
        return !notifications.filter { $0.isChecked == false }.isEmpty
    }
    var viewList: [UserNotification] {
        let list = notifications + readedNotifications
        return list.sorted(by: { $0.addDate > $1.addDate })
    }
    
    var didFetched: Bool = false
    private var dbRef: CollectionReference?
    
    private init() {
        let userId = AuthStore.shared.userUid
        if !userId.isEmpty {
            self.dbRef = Firestore.firestore().collection(StoreCollection.user.path).document(userId).collection(StoreCollection.notification.path)
            self.didFetched = true
            self.fetchNotification()
        }
    }
    
    func readAll() {
        notifications.forEach { notification in
            readNotifications(noti: notification)
        }
    }
    
    func readNotifications(noti: UserNotification) {
        if noti.duplicationIds == nil {
            readSingleNotification(notiId: noti.id ?? "")
        } else {
            readCombinedNotifications(notiId: noti.id ?? "")
        }
    }
    
    /// 하나의 notification을 읽었을 시
    private func readSingleNotification(notiId: String) {
        guard let index = notifications.firstIndex(where: { $0.id == notiId} ) else {
            return
        }
        // 파이어 베이스에서는 제거하고 읽은데이터는 가지고 있다가 앱종료 시 사라지도록
        notifications[index].isChecked = true
        readedNotifications.append(notifications[index])
        notifications.remove(at: index)
        
        guard let dbRef = dbRef else {
            return
        }
        dbRef.document(notiId).delete()
    }
    
    /// 힙쳐진 notification을 읽었을 시
    private func readCombinedNotifications(notiId: String) {
        guard let index = notifications.firstIndex(where: { $0.id == notiId} ) else {
            return
        }
        guard let notiIds = notifications[index].duplicationIds else {
            return
        }
        
        for notiId in notiIds {
            guard let dbRef = dbRef else {
                return
            }
            dbRef.document(notiId).delete()
        }
            
        // 파이어 베이스에서는 제거하고 읽은데이터는 가지고 있다가 앱종료 시 사라지도록
        notifications[index].isChecked = true
        readedNotifications.append(notifications[index])
        notifications.remove(at: index)
        
    }
    
    func setDuplicateNotifications(_ notifications: [UserNotification]) -> [UserNotification] {
        var chattingNotis: [UserNotification] = []
        var travelNotis: [UserNotification] = []
        var noticeNotis: [UserNotification] = []
        var inviteNotis: [UserNotification] = []
        for notification in notifications {
            switch notification.type {
            case .chatting:
                chattingNotis.append(notification)
            case .travel:
                travelNotis.append(notification)
            case .notice:
                noticeNotis.append(notification)
            case .invite:
                inviteNotis.append(notification)
            }
        }
        
        let chattingResult: [UserNotification] = convertDuplicateNotifications(chattingNotis)
        let travelResult: [UserNotification] = convertDuplicateNotifications(travelNotis)
        
        let result = chattingResult + travelResult + noticeNotis + inviteNotis
        
        return result
    }
    
    private func convertDuplicateNotifications(_ notis: [UserNotification]) -> [UserNotification] {
        var chattingResult: [UserNotification] = []

        for noti in notis {
            guard let notiIndex = chattingResult.firstIndex(where: { $0.contentId == noti.contentId }) else {
                let noti = UserNotification(id: UUID().uuidString, duplicationIds: [noti.id ?? ""], type: .chatting, content: noti.content, contentId: noti.contentId, addDate: noti.addDate, isChecked: noti.isChecked)
                chattingResult.append(noti)
                continue
            }
            chattingResult[notiIndex].duplicationIds!.append(noti.id!)
            if chattingResult[notiIndex].addDate < noti.addDate {
                chattingResult[notiIndex].addDate = noti.addDate
            }
        }
        
        return chattingResult
    }
    
    func deleteNotification(_ notification: UserNotification) {
        if notification.isChecked {
            if let index = readedNotifications.firstIndex(where: { $0.id == notification.id }) {
                readedNotifications.remove(at: index)
            }
        } else {
            if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
                guard let dbRef = dbRef else { return }
                var notiIds: [String] = []
                if notification.duplicationIds == nil {
                    notiIds.append(notification.id ?? "")
                } else {
                    notiIds = notification.duplicationIds ?? []
                }
                for notiId in notiIds {
                    dbRef.document(notiId).delete()
                }
                notifications.remove(at: index)
            }
        }
    }
    
    func resetStore() {
        notifications = []
        dbRef = nil
        didFetched = false
    }
    
    func getUserUid() {
        let userId = AuthStore.shared.userUid
        self.dbRef = Firestore.firestore().collection(StoreCollection.user.path).document(userId).collection(StoreCollection.notification.path)
        self.didFetched = true
        self.fetchNotification()
    }
    
    func fetchNotification() {
        guard let dbRef = dbRef else { return }
        Task {
            do {
                var thumpNotis: [UserNotification] = []
                let snapShot = try await dbRef.getDocuments()
                for document in snapShot.documents {
                    let noti = try document.data(as: UserNotification.self)
                    thumpNotis.append(noti)
                }
                thumpNotis.sort(by: { $0.addDate > $1.addDate })
                DispatchQueue.main.async {
                    self.notifications = thumpNotis
                }
            } catch {
                print("fetch false notifications - \(error)")
            }
        }
    }
    
    /// 여행방 갱신, 채팅을 맴버들에게 보낼 시
    func sendNotification(members: [TravelCalculation.Member], notification: UserNotification) {
        let members = members.filter { $0.userId != nil }
        Task {
            for member in members {
                do {
                    try Firestore.firestore().collection("User").document(member.userId ?? "").collection("Notification").addDocument(from: notification.self)
                } catch {
                    print("false send notification to \(member.name) - \(error)")
                }
            }
        }
    }
    
    /// 유저에게 직접 보낼 시
    func sendNotification(users: [User], notification: UserNotification) {
        Task {
            for user in users {
                do {
                    try Firestore.firestore().collection("User").document(user.id ?? "").collection("Notification").addDocument(from: notification.self)
                } catch {
                    print("false send notification to \(user.name) - \(error)")
                }
            }
        }
    }
    
    func setNotificationChecked(notiId: String) {
        guard let index = notifications.firstIndex(where: { $0.id == notiId} ) else { return }
        if notifications[index].isChecked == false {
            guard let dbRef = dbRef else { return }
            dbRef.document(notiId).setData(["isChecked": true])
            DispatchQueue.main.async {
                self.notifications[index].isChecked = true
            }
        }
    }
}
