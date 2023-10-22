//
//  NotificationView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct NotificationListView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isAllRead = false
    @EnvironmentObject private var notificationStore: NotificationStore
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(0..<10, id: \.self) { _ in
                    let notification = UserNotification(
                        id: "1",
                        type: .chatting,
                        content: "읽지 않은 메세지를 확인해보세요.",
                        contentId: "someContentID",
                        addDate: Date(),
                        isChecked: false
                    )
                    
                    NotificationCell(notification: notification)
                }
            }
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
}

#Preview {
    NotificationListView()
        .environmentObject(NotificationStore())
}
