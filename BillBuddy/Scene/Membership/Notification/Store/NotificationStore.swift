//
//  NotificationStore.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/20/23.
//

import Foundation
import FirebaseFirestore

final class NotificationStore: ObservableObject {
    @Published var notifications: [UserNotification] = []
    var hasUnReadNoti: Bool {
        return notifications.filter { $0.isChecked == false }.isEmpty
    }
    
    private var dbRef: CollectionReference?
    
    init() {
        let userId = AuthStore.shared.userUid
        if !userId.isEmpty {
            self.dbRef = Firestore.firestore().collection("User").document(userId).collection("Notification")
            self.fetchNotification()
        }
    }
    
    func getUserUid() {
        let userId = AuthStore.shared.userUid
        self.dbRef = Firestore.firestore().collection("User").document(userId).collection("Notification")
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
                notifications = thumpNotis
            } catch {
                print("fetch false notifications - \(error)")
            }
        }
    }
    
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
}
