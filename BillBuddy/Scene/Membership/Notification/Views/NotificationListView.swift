//
//  NotificationView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct NotificationListView: View {
    @StateObject var notificationManager = NotificationManager()
    @Environment(\.dismiss) private var dismiss
    @State private var isAllRead = false
    @State private var isChatRead = false
    @State private var isNoticeRead = false
    @State private var isExpenseRead = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                NavigationLink(destination: ChatNotifincationCell(isRead: $isChatRead)) {
                    ChatNotifincationCell(isRead: $isChatRead)
                }
                NavigationLink(destination: ChatNoticeAlarmCell(isRead: $isNoticeRead)) {
                    ChatNoticeAlarmCell(isRead: $isNoticeRead)
                }
                NavigationLink(destination: TravelExpenseCell(isRead: $isExpenseRead)) {
                    TravelExpenseCell(isRead: $isExpenseRead)
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
                    isChatRead = isAllRead
                    isNoticeRead = isAllRead
                    isExpenseRead = isAllRead
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
}
