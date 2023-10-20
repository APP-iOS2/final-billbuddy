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
            HStack {
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
                VStack {
                    NavigationLink {
                        DetailMainView(paymentStore: PaymentStore(travel: travel), travelDetailStore: TravelDetailStore(travel: travel))
                    } label: {
                        Image(.steps13)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .overlay(
                Rectangle()
                    .frame(width: nil, height: 1)
                    .foregroundColor(Color.gray050), alignment: .bottom)
            .padding(.bottom, 10)
            VStack {
                HStack {
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
                Text("정규시즌 4~5위팀이 맞붙는 KBO 와일드카드 결정전은 4위팀이 1승을 안고 시리즈를 치른다. 따라서 4위팀은 1차전에서 승리하거나 무승부를 해도 준플레이오프 진출에 성공할 수 있다. 반면 5위팀은 1차전은 물론 2차전까지 잡아야 준플레이오프 진출이 가능하다. 역대 와일드카드 결정전에서는 4위팀이 모두 준플레이오프 진출에 성공했다. 이번에도 그랬다. 이날 NC의 승리로 '100%의 법칙'이 이어졌다. 2015년 넥센, ")
                    .font(.body04)
                    .foregroundColor(.gray700)
                Spacer()
            }
            .frame(height: 205)
            .frame(maxWidth: .infinity)
            .overlay(
                Rectangle()
                    .frame(width: nil, height: 1)
                    .foregroundColor(Color.gray050), alignment: .bottom)
            .padding(.bottom, 10)
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
            .frame(height: 350)
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .padding(.horizontal, 16)
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
}

#Preview {
    ChattingMenuView(travel: TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: []))
}
