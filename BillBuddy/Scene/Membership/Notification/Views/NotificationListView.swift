//
//  NotificationView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct NotificationListView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isAllRead = false
    @EnvironmentObject private var notificationStore: NotificationStore
    
    private var db = Firestore.firestore()
    @State private var notifications: [UserNotification] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(notifications, id: \.id) { notification in
                    NotificationCell(notification: notification)
                }
            }
        }
        .onAppear {
            fetchNotifications()
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(.arrowBack)
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isAllRead.toggle()
                }, label: {
                    Text("모두읽음")
                        .font(.body01)
                        .foregroundColor(isAllRead ? Color.gray : Color.myPrimary)
                })
                .disabled(isAllRead)
            }
            ToolbarItem(placement: .principal) {
                Text("알림")
                    .font(.title05)
            }
        })
    }
    
    private func fetchNotifications() {
        db.collection("User").document(AuthStore.shared.userUid).collection("Notification").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching notifications: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    if let notification = try? document.data(as: UserNotification.self) {
                        notifications.append(notification)
                    }
                }
            }
        }
    }
}

#Preview {
    NotificationListView()
        .environmentObject(NotificationStore())
}
