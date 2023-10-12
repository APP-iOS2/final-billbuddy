//
//  ChattingView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct ChattingView: View {
    @EnvironmentObject var chatStore: ChatStore
    private let userId = AuthStore.shared.userUid
    
    var body: some View {
        NavigationStack {
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
                chatStore.fetchChatList()
            }
            .navigationTitle("채팅")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        Image("ringing-bell-notification-3")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.systemBlack)
                    })
                }
            }
        }
    }
    
    private var chattingItems: some View {
        ForEach(chatStore.chats) { chat in
            NavigationLink {
                ChattingRoomView()
            } label: {
                HStack {
                    Circle()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.gray200)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(chat.travelTitle)
                                .font(Font.body02)
                                .foregroundColor(.systemBlack)
                            
                            Text("\(chat.memberIds.count)")
                                .font(Font.body02)
                                .foregroundColor(.gray500)
                        }
                        if let messagePreview = chat.lastMessage {
                            Text(messagePreview)
                                .font(Font.body04)
                                .foregroundColor(.gray700)
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        // TODO: 더블타입 오전 HH:mm 로 변환하기 - Double+Extension.swift
                        if let lastMessageTime = chat.lastMessageDate {
                            Text("\(lastMessageTime)")
                                .font(Font.caption01)
                                .foregroundColor(.gray500)
                        }
                        if let unreadMessage = chat.unreadMessageCount?[userId], unreadMessage > 0 {
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
    ChattingView()
        .environmentObject(ChatStore())
}
