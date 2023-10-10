//
//  ChattingView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct ChattingView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    chattingItems
                        .padding(.top, 5)
                        .overlay(
                            Rectangle()
                                .frame(height: 1, alignment: .top)
                                .foregroundColor(.systemGray02), alignment: .top
                        )
                }
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
        ForEach(0..<3, id: \.self) { data in
            NavigationLink {
                ChattingRoomView()
            } label: {
                HStack {
                    Circle()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.systemGray03)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("신나는 유럽여행")
                                .font(Font.body02)
                                .foregroundColor(.systemBlack)
                            
                            Text("8")
                                .font(Font.body02)
                                .foregroundColor(.systemGray06)
                        }
                        Text("채팅미리보기")
                            .font(Font.body04)
                            .foregroundColor(.systemGray08)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("오후 2:27")
                            .font(Font.caption01)
                            .foregroundColor(.systemGray06)
                        Text("5")
                            .frame(width: 16, height: 16)
                            .font(Font.caption03)
                            .foregroundColor(.white)
                            .background(Color.error)
                            .cornerRadius(50)
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
}
