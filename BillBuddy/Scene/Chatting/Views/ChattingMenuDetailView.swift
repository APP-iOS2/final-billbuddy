//
//  ChattingMenuDetailView.swift
//  BillBuddy
//
//  Created by yuri rho on 10/24/23.
//

import SwiftUI

struct ChattingMenuDetailView: View {
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
                LazyVGrid(columns: columns) {
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
            }
        }
    }
}

#Preview {
    ChattingMenuDetailView(selection: "사진", travel: TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: []))
}
