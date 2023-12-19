//
//  ChattingMenuView.swift
//  BillBuddy
//
//  Created by yuri rho on 10/20/23.
//

import SwiftUI
import Kingfisher

struct ChattingMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userTravelStore: UserTravelStore
    @EnvironmentObject private var messageStore: MessageStore
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
        .onAppear {
            messageStore.getChatRoomData(travelCalculation: travel)
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
                Text("\(travel.members.count)명 \(travel.startDate.toFormattedYearandMonthandDay()) - \(travel.endDate.toFormattedYearandMonthandDay())")
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
            
            if let noticeExist = messageStore.travel.chatNotice {
                ForEach(noticeExist.reversed().prefix(1), id: \.self) { notice in
                    Text(notice.notice)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(6)
                        .lineSpacing(3)
                        .font(.body04)
                        .foregroundColor(.gray700)
                        .padding(.bottom, 50)
                }
            } else {
                Text("등록된 공지가 없습니다.")
                    .font(Font.body04)
                    .foregroundColor(.gray500)
                    .padding()
            }
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
            
            if let existImageList = messageStore.travel.chatImages {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]) {
                    ForEach(existImageList.reversed().prefix(6), id: \.self) { image in
                        KFImage(URL(string: image))
                            .placeholder{
                                ProgressView()
                                    .frame(width:112, height: 112)
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:112, height: 112)
                    }
                }
            } else {
                VStack {
                    Text("등록된 사진이 없습니다.")
                        .font(Font.body04)
                        .foregroundColor(.gray500)
                        .padding()
                    Spacer()
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
            .alert("여행을 나가시겠습니까", isPresented: $isPresentedLeaveAlert) {
                Button("머물기", role: .cancel) { }
                Button("여행 떠나기", role: .destructive) {
                    userTravelStore.leaveTravel(travel: travel)
                    tabViewStore.poToRoow()
                }
            }
    }
}

#Preview {
    ChattingMenuView(travel: TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: []))
        .environmentObject(UserTravelStore())
        .environmentObject(MessageStore())
        .environmentObject(TabViewStore())
}
