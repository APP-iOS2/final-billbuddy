//
//  MyPage.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

import SwiftUI

struct MyPageView: View {
    
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var notificationStore: NotificationStore

    var body: some View {
        VStack {
            MyPageDetailView()
            MyPageSettingView()
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("마이페이지")
                    .font(.title05)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    NotificationListView()
                }label: {
                    Image("ringing-bell-notification-3")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.systemBlack)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyPageView()
            .environmentObject(UserService.shared)
            .environmentObject(NotificationStore())
    }
}
