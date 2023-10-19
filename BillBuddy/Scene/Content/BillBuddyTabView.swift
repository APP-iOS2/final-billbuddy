//
//  TabView.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/4/23.
//

import SwiftUI
import UIKit

struct BillBuddyTabView: View {
    @State private var selectedTab = 0
    @StateObject private var floatingButtonMenuStore = FloatingButtonMenuStore()
    @State var tabBarVisivility: Visibility = .visible
//    @State var isDimmedBackground = false

    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.gray500)
        UITabBarItem.appearance().setTitleTextAttributes([.font:UIFont(name: "Pretendard-Bold", size: 10)!], for: .normal)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                TravelListView(floatingButtonMenuStore: floatingButtonMenuStore, tabBarVisivility: $tabBarVisivility)
                    
            }
            .tabItem {
                Image(.hometap)
                    .renderingMode(.template)
                Text("홈")
            }
//            .brightness(isDimmedBackground ? -0.5 : 0)
            .toolbarBackground(Color.systemBlack.opacity(floatingButtonMenuStore.isDimmedBackground ? 0.5 : 0), for: .tabBar)
            .tag(0)
            
            NavigationStack {
                ChattingView()
            }
            .tabItem {
                Image(.chattap)
                    .renderingMode(.template)
                Text("채팅")
            }
            .tag(1)
            
            NavigationStack {
                MyPageView()
            }
            .tabItem {
                Image(.mypagetap)
                    .renderingMode(.template)
                Text("마이페이지")
            }

            .tag(2)
        }
        .accentColor(.systemBlack)
    }
}

#Preview {
    BillBuddyTabView()
}
