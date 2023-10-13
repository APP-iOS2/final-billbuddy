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
    @State var travel: TravelCalculation
    @State private var inputText: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                if let activeChat = travel.lastMessage {
                    chattingItem
                } else {
                    Text("여행 친구들과 대화를 시작해보세요")
                        .font(Font.body04)
                        .foregroundColor(.gray500)
                        .padding()
                } 
            }
            VStack {
                chattingInputBar
            }
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
        ForEach(0..<15) { data in
            HStack {
                Spacer()
                VStack {
                 Spacer()
                    Text("오후 6:03")
                        .font(Font.caption02)
                        .foregroundColor(.gray500)
                }
                VStack {
                    Text("김상인")
                        .font(Font.caption02)
                        .foregroundColor(.systemBlack)
                    Text("안녕?")
                        .font(Font.body04)
                        .foregroundColor(.systemBlack)
                        .padding()
                        .background(Color.gray050)
                        .cornerRadius(12)
                }
                VStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray500)
                    Spacer()
                }
            }
            .padding(.horizontal)
            .padding(.top, 5)
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
