//
//  NotificationView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct NotificationListView: View {
    @State private var isAllRead = false
    
    var body: some View {
        ZStack {
            ScrollView {
                ForEach(0..<10) { _ in
                    ChatNotifincationCell()
                }
            }
        }
        .navigationBarTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    
                }, label: {
                    Text("모두읽음")
                        .font(.body01)
                        .foregroundColor(Color.myPrimary)
                })
            }
        }
    }
}

#Preview {
    NotificationListView()
}
