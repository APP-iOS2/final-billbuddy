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
                chattingItems
            }
            .navigationTitle("BillBuddy")
        }
    }
    
    private var chattingItems: some View {
        ScrollView {
            ForEach(0..<3, id: \.self) { data in
                NavigationLink {
                    ChattingRoomView()
                } label: {
                    VStack(alignment: .leading) {
                        Text("신나는 유럽여행")
                            .font(Font.body01)
                            .foregroundColor(.systemBlack)
                            .padding(.vertical, 1)
                        Text("채팅미리보기")
                            .font(Font.caption01)
                            .foregroundColor(.systemGray07)
                    }
                    Spacer()
                    Text("7시간 전")
                        .font(Font.body04)
                        .foregroundColor(.systemBlack)
                    
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .frame(height: 90)
                .background(Color.positive)
                .cornerRadius(12)
            }
            .padding(10)
        }
    }
}

#Preview {
    ChattingView()
}
