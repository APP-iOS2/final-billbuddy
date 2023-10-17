//
//  TabView.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/4/23.
//

import SwiftUI

struct BillBuddyTabView: View {
    @State private var selectedTab = 0
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.gray500)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                TravelListView()
            }
            .tabItem {
                Image(.hometap)
                    .renderingMode(.template)
                Text("test")
            }
            .frame(width: 50, height: 44)
            .tag(0)
            
            NavigationStack {
                ChattingView()
            }
            .tabItem {
                Image(.chattap)
                    .renderingMode(.template)
                Text("test")
            }
            .tag(1)
            
            NavigationStack {
                MyPageView()
            }
            .tabItem {
                Image(.mypagetap)
                    .renderingMode(.template)
                Text("test")
            }
            .frame(width: 50, height: 44)

            .tag(2)
        }
        .accentColor(.systemBlack)
    }
}

#Preview {
    BillBuddyTabView()
        .environmentObject(SettlementExpensesStore())
        .environmentObject(UserService.shared)
        .environmentObject(MessageStore())
        .environmentObject(UserService.shared)
}
