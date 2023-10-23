//
//  ChattingMenuView.swift
//  BillBuddy
//
//  Created by yuri rho on 10/20/23.
//

import SwiftUI

struct ChattingMenuView: View {
    @Environment(\.dismiss) private var dismiss
    var travel: TravelCalculation
    
    var body: some View {
        VStack {
            VStack {
                titleView
                noticeView
                photoView
            }
            .padding(.horizontal, 16)
            Spacer()
            exitView
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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
        }
    }
    
    private var titleView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(travel.travelTitle)
                    .font(.title05)
                    .foregroundColor(.systemBlack)
                    .frame(alignment: .leading)
                Text("\(travel.members.count)명 \(travel.startDate.toFormattedDate()) 개설")
                    .font(.body04)
                    .foregroundColor(.gray600)
            }
            Spacer()
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .overlay(
            Rectangle()
                .frame(width: nil, height: 1)
                .foregroundColor(Color.gray050), alignment: .bottom)
        .padding(.bottom, 10)
    }
    
    private var noticeView: some View {
        VStack {
            HStack() {
                Image(.announcementMegaphone)
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("공지")
                    .font(.body04)
                    .foregroundColor(.gray900)
                Spacer()
                NavigationLink {
                    
                } label: {
                    Image(.chevronRight)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.bottom, 10)
            Text("공지사항입니다. 기차 출발 삼십분 전에는 꼬옥 도착하기로해요~ 아시겠어요????")
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(6)
                .lineSpacing(3)
                .font(.body04)
                .foregroundColor(.gray700)
                .padding(.bottom, 50)
            Spacer()
        }
        .frame(minHeight: 200)
        .frame(maxWidth: .infinity)
        .overlay(
            Rectangle()
                .frame(width: nil, height: 1)
                .foregroundColor(Color.gray050), alignment: .bottom)
        .padding(.bottom, 10)
    }
    
    private var photoView: some View {
        VStack {
            HStack {
                Image(.gallery)
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("사진")
                    .font(.body04)
                    .foregroundColor(.gray900)
                Spacer()
                NavigationLink {
                    
                } label: {
                    Image(.chevronRight)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.bottom, 10)
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 100))
            ], spacing: 12) {
                ForEach(0..<3) { image in
                    Rectangle()
                        .frame(width: 112, height: 112)
                }
            }
            Spacer()
        }
        .frame(minHeight: 280)
        .frame(maxWidth: .infinity)
    }
    
    private var exitView: some View {
        HStack(alignment: .bottom) {
            Button(action: {
                
            }, label: {
                Image(.exit)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray600)
                Text("나가기")
                    .font(.body04)
                    .foregroundColor(.gray600)
            })
            Spacer()
        }
        .padding(16)
        .frame(height: 83)
        .frame(maxWidth: .infinity)
        .background(Color.gray050)
    }
}

#Preview {
    ChattingMenuView(travel: TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: []))
}
