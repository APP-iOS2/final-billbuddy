//
//  ChattingMenuDetailView.swift
//  BillBuddy
//
//  Created by yuri rho on 10/24/23.
//

import SwiftUI

struct ChattingMenuDetailView: View {
    @EnvironmentObject private var messageStore: MessageStore
    @Environment(\.dismiss) private var dismiss
    @State var selection: String
    
    var travel: TravelCalculation
    let menus: [String] = ["공지", "사진"]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray100)
            VStack {
                HStack {
                    menuSelection
                    Spacer()
                }
                .padding(.top)
                VStack {
                    if selection == "공지" {
                        noticeList
                    } else if selection == "사진" {
                        photoList
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            Task {
                await messageStore.getChatRoomData(travelCalculation: travel)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(.close)
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
            ToolbarItem(placement: .principal) {
                Text(travel.travelTitle)
            }
        }
    }
    
    private var menuSelection: some View {
        HStack(spacing: 0) {
            ForEach(menus, id: \.self) { menu in
                Button {
                    selection = menu
                } label: {
                    VStack {
                        Text(menu)
                            .font(.body02)
                            .foregroundColor(selection == menu ? .systemBlack : .gray500)
                        if selection == menu {
                            Capsule()
                                .frame(width: 45, height: 3)
                                .foregroundColor(.systemBlack)
                        } else {
                            Capsule()
                                .frame(width: 45, height: 3)
                                .foregroundColor(.gray100)
                        }
                    }
                }
            }
        }
    }
    
    private var noticeList: some View {
        ScrollView {
            ForEach(0..<1) { item in
                VStack(spacing: 3) {
                    HStack {
                        Text("늦으면 버리고 갑니다.")
                            .font(.body04)
                            .foregroundColor(.systemBlack)
                        Spacer()
                    }
                    HStack {
                        Text("2023.10.20")
                            .font(.caption02)
                            .foregroundColor(.gray600)
                        Text("윤지호")
                            .font(.caption02)
                            .foregroundColor(.gray600)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 64)
            }
        }
    }
    
    private var photoList: some View {
        VStack {
            HStack {
                Text("3개")
                    .font(.caption02)
                    .foregroundColor(.gray600)
                Spacer()
            }
            .padding(.vertical, 3)
            ScrollView {
                if let existImageList = messageStore.travel.chatImages {
                    LazyVGrid(columns: columns) {
                        ForEach(existImageList.reversed(), id: \.self) { image in
                            AsyncImage(url: URL(string: image)) { img in
                                img
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:112, height: 112)
                            } placeholder: {
                                ProgressView()
                                    .frame(width:112, height: 112)
                            }
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
            }
        }
    }
}

#Preview {
    ChattingMenuDetailView(selection: "사진", travel: TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: []))
        .environmentObject(MessageStore())
}
