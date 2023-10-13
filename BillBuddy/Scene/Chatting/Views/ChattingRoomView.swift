//
//  ChattingRoomView.swift
//  BillBuddy
//
//  Created by yuri rho on 2023/10/04.
//

import SwiftUI

struct ChattingRoomView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var messageStore: MessageStore
    var travel: TravelCalculation
    @State private var inputText: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                if messageStore.messages.isEmpty {
                    Text("여행 친구들과 대화를 시작해보세요")
                        .font(Font.body04)
                        .foregroundColor(.gray500)
                        .padding()
                } else {
                    chattingItem
                }
            }
            VStack {
                chattingInputBar
            }
        }
        .onAppear {
            messageStore.fetchMessages(travelCalculation: travel)
        }
        .navigationTitle(travel.travelTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    mode.wrappedValue.dismiss()
                }, label: {
                    Image("arrow_back")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    
                }, label: {
                    Image("steps-1 3")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
        }
    }
    
    private var chattingItem: some View {
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
    }
    
    private var chattingInputBar: some View {
        HStack() {
            TextField("내용을 입력해주세요", text: $inputText)
                .padding()
            Button {
                
            } label: {
                Image("emoji")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray600)
            }
            Button {
                let newMessage = Message(senderId: AuthStore.shared.userUid, message: inputText, sendDate: Date().timeIntervalSince1970, isRead: false)
                messageStore.sendMessage(travelCalculation: travel, message: newMessage)
                inputText.removeAll()
            } label: {
                Image("mail-send-email-message-35")
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
    }
}
