//
//  ChattingRoomView.swift
//  BillBuddy
//
//  Created by yuri rho on 2023/10/04.
//

import SwiftUI

struct ChattingRoomView: View {
    
    @State private var inputText: String = ""
    
    var body: some View {
        ZStack {
            chattingItem
            VStack {
                Spacer()
                chattingInputBar
            }
        }
        .navigationTitle("신나는 유럽여행")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var chattingItem: some View {
        ScrollView {
            ForEach(0..<1) { data in
                HStack {
                    Spacer()
                    HStack {
                        Text("안녕?")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.positive)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 3)
            }
            HStack{
                Spacer()
            }
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
    }
    
    private var chattingInputBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.badge.plus")
                .font(.system(size: 24))
                .foregroundColor(.systemGray08)
            TextField("내용을 입력해주세요", text: $inputText)
            Button {
                
            } label: {
                Text("보내기")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.positive)
            .cornerRadius(10)
        }
        .padding(.horizontal, 20)
        .frame(height: 40)
        .background(Color.white)
    }
}

#Preview {
    ChattingRoomView()
}
