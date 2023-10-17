//
//  TabView.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/4/23.
//

import SwiftUI

struct BillBuddyTabView: View {
    @State private var selectedTab = 0
  
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                TravelListView()
            }
            .tabItem { Text("홈") }
            .tag(0)
            NavigationStack {
                ChattingView()
            }
            .tabItem { Text("채팅") }
            .tag(1)
            NavigationStack {
                MyPageView()
            }
            .tabItem { Text("마이페이지") }
            .tag(2)
        }
    }
}

#Preview {
    BillBuddyTabView()
}
