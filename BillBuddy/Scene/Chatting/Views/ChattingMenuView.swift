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
                    ChattingMenuDetailView(selection: "공지", travel: travel)
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
        .frame(minHeight: 100)
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
                    ChattingMenuDetailView(selection: "사진", travel: travel)
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
                AsyncImage(url: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/billbuddy-6de01.appspot.com/o/chat%2F3E720E57-2CEA-4CA1-A921-B0C4236EDBB5%2FB37138E7-C45E-450E-B46C-26065E79155B.jpeg?alt=media&token=14272592-2a1f-4ffd-a392-dbb42cfa75ce")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:112, height: 112)
                } placeholder: {
                    ProgressView()
                        .frame(width:112, height: 112)
                }
                AsyncImage(url: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/billbuddy-6de01.appspot.com/o/chat%2F3E720E57-2CEA-4CA1-A921-B0C4236EDBB5%2FB745C0F1-33B6-4009-900A-C755491BEB17.jpeg?alt=media&token=b79b160a-9569-417d-a8a1-d74bef7b3a40")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:112, height: 112)
                } placeholder: {
                    ProgressView()
                        .frame(width:112, height: 112)
                }
                AsyncImage(url: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/billbuddy-6de01.appspot.com/o/chat%2FB8C13D17-5F29-4EAD-B725-D19499385248%2F4D336765-6D93-4220-9F74-27A862E16954.jpeg?alt=media&token=a34f9d7b-20e7-462b-9714-a4341ca9851b")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:112, height: 112)
                } placeholder: {
                    ProgressView()
                        .frame(width:112, height: 112)
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
