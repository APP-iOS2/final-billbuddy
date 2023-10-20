//
//  ChattingView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct ChattingView: View {
    @EnvironmentObject private var travelStore: UserTravelStore
    @EnvironmentObject private var notificationStore: NotificationStore
    @EnvironmentObject private var tabBarVisivilyStore: TabBarVisivilyStore
    
    var body: some View {
        VStack {
            ScrollView {
                chattingItems
                    .padding(.top, 5)
                    .overlay(
                        Rectangle()
                            .frame(height: 1, alignment: .top)
                            .foregroundColor(.gray100), alignment: .top
                    )
            }
        }
        .onAppear {
            tabBarVisivilyStore.showTabBar()
            if !AuthStore.shared.userUid.isEmpty {
                travelStore.fetchTravelCalculation()
            }
        }
        .toolbar(tabBarVisivilyStore.visivility, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("채팅")
                    .font(.title05)
                    .foregroundColor(.systemBlack)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    NotificationListView()
                } label: {
                    Image(.ringingBellNotification3)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.systemBlack)
                }
            }
        }
    }
    
    private var chattingItems: some View {
        ForEach(travelStore.travels) { travel in
            NavigationLink {
                ChattingRoomView(travel: travel)

            } label: {
                HStack {
                    Circle()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.gray200)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(travel.travelTitle)
                                .font(Font.body02)
                                .foregroundColor(.systemBlack)
                            
                            Text("\(travel.members.count)")
                                .font(Font.body02)
                                .foregroundColor(.gray500)
                        }
                        if let messagePreview = travel.lastMessage {
                            Text(messagePreview)
                                .font(Font.body04)
                                .foregroundColor(.gray700)
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        if let lastMessageTime = travel.lastMessageDate?.toFormattedChatDate() {
                            Text("\(lastMessageTime)")
                                .font(Font.caption01)
                                .foregroundColor(.gray500)
                        }
                        if let unreadMessage = travel.unreadMessageCount?[AuthStore.shared.userUid], unreadMessage > 0 {
                            Text("\(unreadMessage)")
                                .frame(width: 16, height: 16)
                                .font(Font.caption03)
                                .foregroundColor(.white)
                                .background(Color.error)
                                .cornerRadius(50)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 80)
        }
        .padding(2)
    }
}

#Preview {
    NavigationStack {
        ChattingView()
            .environmentObject(UserTravelStore())
            .environmentObject(TabBarVisivilyStore())
            .environmentObject(NotificationStore())
    }
}

