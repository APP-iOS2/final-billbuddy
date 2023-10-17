//
//  TabView.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/4/23.
//

import SwiftUI

struct BillBuddyTabView: View {
    @State private var selectedTab = 0
    @State var tabBarVisivility: Visibility = .visible

    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.gray500)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                TravelListView(tabBarVisivility: $tabBarVisivility)
                    .toolbar(tabBarVisivility, for: .tabBar)
            }
            .tabItem {
                Image(.hometap)
                    .renderingMode(.template)
                Text("test")
            }
            .tag(0)
            
            NavigationStack {
                ChattingView(tabBarVisivility: $tabBarVisivility)
                    .toolbar(tabBarVisivility, for: .tabBar)

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

            .tag(2)
        }
        .accentColor(.systemBlack)
    }
}

#Preview {
    BillBuddyTabView()
}
