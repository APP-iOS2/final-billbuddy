//
//  ChattingMenuView.swift
//  BillBuddy
//
//  Created by yuri rho on 10/20/23.
//

import SwiftUI

struct ChattingMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userTravelStore: UserTravelStore
    @EnvironmentObject private var tabViewStore: TabViewStore
    @State private var isPresentedLeaveAlert: Bool = false
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
        .ignoresSafeArea(.all, edges: .bottom)
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
                AsyncImage(url: URL(string: "https://cdn.discordapp.com/attachments/1153285644345417808/1166330851068481576/IMG_08E8F2FC92C8-1.jpeg?ex=654a1940&is=6537a440&hm=e87507612dbf2aa7d3ef3687584525291c51391574cf34071ff702444ac9b34f&")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:112, height: 112)
                } placeholder: {
                    ProgressView()
                        .frame(width:112, height: 112)
                }
                AsyncImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/billbuddy-6de01.appspot.com/o/chat%2FB8C13D17-5F29-4EAD-B725-D19499385248%2F207331C0-607C-42C3-8C1D-D6D9E4FB0704.jpeg?alt=media&token=e39f9b1c-8baf-40cf-b0ed-965d2b7889c7&_gl=1*1dnu1kr*_ga*MjA4MDU0NTgyNS4xNjkxMDU5NjQ2*_ga_CW55HF8NVT*MTY5ODE0NTI1NC4xNDkuMC4xNjk4MTQ1MjU0LjYwLjAuMA..")) { image in
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
        Rectangle()
            .frame(height: 83)
            .foregroundStyle(Color.gray050)
            .overlay(alignment: .init(horizontal: .leading, vertical: .top)) {
                Button {
                    isPresentedLeaveAlert = true

                } label: {
                    HStack {
                        Image(.exit)
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("나가기")
                            .foregroundStyle(Color.gray600)
                            .font(Font.body04)
                    }
                }
                .padding(EdgeInsets(top: 18, leading: 16, bottom: 0, trailing: 0))
            }
//        HStack(alignment: .bottom) {
//            Button(action: {
//                
//            }, label: {
//                Image(.exit)
//                    .resizable()
//                    .frame(width: 24, height: 24)
//                    .foregroundColor(.gray600)
//                Text("나가기")
//                    .font(.body04)
//                    .foregroundColor(.gray600)
//            })
//            Spacer()
//        }
//        .padding(16)
//        .frame(height: 83)
//        .frame(maxWidth: .infinity)
//        .background(Color.gray050)
        .alert("여행을 나가시겠습니까", isPresented: $isPresentedLeaveAlert) {
            Button("머물기", role: .cancel) { }
            Button("여행 떠나기", role: .destructive) {
                userTravelStore.leaveTravel(travel: travel)
                tabViewStore.popToRoow()
            }

        }
    }
        
}

#Preview {
    ChattingMenuView(travel: TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: []))
        .environmentObject(UserTravelStore())
        .environmentObject(TabViewStore())
}
