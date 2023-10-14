//
//  MyPage.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

import SwiftUI

struct MyPageView: View {
    
    @EnvironmentObject var userService: UserService
    
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
                Image("ringing-bell-notification-3")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.systemBlack)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyPageView()
            .environmentObject(UserService.shared)
    }
}
