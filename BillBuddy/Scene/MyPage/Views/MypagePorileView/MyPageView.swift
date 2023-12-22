//
//  MyPage.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

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
        Divider().padding(0)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("마이페이지")
                    .font(.title05)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    NotificationListView()
                }label: {
                    if notificationStore.hasUnReadNoti {
                        Image(.redDotRingBell)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    else {
                        Image("ringing-bell-notification-3")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyPageView()
            .environmentObject(UserService.shared)
            .environmentObject(NotificationStore.shared)
    }
}
