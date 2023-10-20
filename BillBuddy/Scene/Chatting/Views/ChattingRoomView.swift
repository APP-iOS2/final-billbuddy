//
//  ChattingRoomView.swift
//  BillBuddy
//
//  Created by yuri rho on 2023/10/04.
//

import SwiftUI

struct ChattingRoomView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var messageStore: MessageStore
    @EnvironmentObject private var tabBarVisivilyStore: TabBarVisivilyStore
    var travel: TravelCalculation
    @State private var inputText: String = ""
    
    var body: some View {
        VStack {
            if messageStore.messages.isEmpty {
                emptyChat
            } else {
                chattingItem
            }
            chattingInputBar
        }
        .onAppear {
            tabBarVisivilyStore.hideTabBar()
            messageStore.fetchMessages(travelCalculation: travel)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(tabBarVisivilyStore.visivility, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(.arrowBack)
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
            ToolbarItem(placement: .principal) {
                Text(travel.travelTitle)
                    .font(.title05)
                    .foregroundColor(.systemBlack)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    ChattingMenuView(travel: travel)
                } label: {
                    Image(.steps13)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
    
    private var emptyChat: some View {
        VStack {
            Text("여행 친구들과 대화를 시작해보세요")
                .font(Font.body04)
                .foregroundColor(.gray500)
                .padding()
            Spacer()
        }
    }
    
    private var chattingItem: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                ForEach(messageStore.messages) { message in
                    if message.senderId == AuthStore.shared.userUid {
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(message.senderId)
                                    .font(Font.caption02)
                                    .foregroundColor(.systemBlack)
                                HStack {
                                    VStack {
                                        Spacer()
                                        Text(message.sendDate.toFormattedChatDate())
                                            .font(Font.caption02)
                                            .foregroundColor(.gray500)
                                    }
                                    Text(message.message)
                                        .font(Font.body04)
                                        .foregroundColor(.systemBlack)
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .background(Color(hex: "#DEEBFF"))
                                        .cornerRadius(12)
                                }
                            }
                            VStack {
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray500)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                    } else {
                        HStack {
                            VStack {
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray500)
                                Spacer()
                            }
                            VStack(alignment: .leading) {
                                Text(message.senderId)
                                    .font(Font.caption02)
                                    .foregroundColor(.systemBlack)
                                HStack {
                                    Text(message.message)
                                        .font(Font.body04)
                                        .foregroundColor(.systemBlack)
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .background(Color.gray050)
                                        .cornerRadius(12)
                                    VStack {
                                        Spacer()
                                        Text(message.sendDate.toFormattedChatDate())
                                            .font(Font.caption02)
                                            .foregroundColor(.gray500)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                    }
                }
                HStack { }
                    .id("last")
            }
            .onReceive(messageStore.$isAddedNewMessage, perform: { _ in
                if !messageStore.messages.isEmpty {
                    withAnimation {
                        scrollProxy.scrollTo("last", anchor: .bottom)
                    }
                }
            })
        }
    }
    
    private var chattingInputBar: some View {
        HStack() {
            TextField("내용을 입력해주세요", text: $inputText)
                .padding()
            Button {
                
            } label: {
                Image(.emoji)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray600)
            }
            Button {
                let newMessage = Message(senderId: AuthStore.shared.userUid, message: inputText, sendDate: Date().timeIntervalSince1970, isRead: false)
                messageStore.sendMessage(travelCalculation: travel, message: newMessage)
                inputText.removeAll()
            } label: {
                Image(.mailSendEmailMessage35)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray600)
            }
            .padding(.trailing, 10)
        }
        .frame(height: 50)
        .background(Color.gray050)
        .cornerRadius(12)
        .padding(.horizontal, 10)
    }
}

#Preview {
    NavigationStack {
        ChattingRoomView(travel: TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: []))
            .environmentObject(MessageStore())
            .environmentObject(TabBarVisivilyStore())
    }
}
