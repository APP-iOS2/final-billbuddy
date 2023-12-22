//
//  MoreView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/4/23.
//

import SwiftUI

enum EntryViewType {
    case list
    case more
}

enum ListItem: String, CaseIterable {
    case chat
    case editDate
    case mamberManagement
    case settledAccount
    
    var itemName: String {
        switch self {
        case .chat:
            "채팅"
        case .editDate:
            "날짜 관리"
        case .mamberManagement:
            "인원 관리"
        case .settledAccount:
            "정산"
        }
    }
    
    var itemImageString: String {
        switch self {
        case .chat:
            "chat-bubble-text-square1"
        case .editDate:
            "calendar-check-1"
        case .mamberManagement:
            "user-single-neutral-male-4"
        case .settledAccount:
            "script-2-18"
        }
    }
}

struct MoreView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userTravelStore: UserTravelStore
    @EnvironmentObject private var tabViewStore: TabViewStore
    @EnvironmentObject private var travelDetailStore: TravelDetailStore
    @EnvironmentObject private var paymentStore: PaymentStore
    @State var itemList: [ListItem] = ListItem.allCases
    @State var isPresentedLeaveAlert: Bool = false
    
    let travel: TravelCalculation

    var body: some View {
        VStack {
            
            Spacer()

            ScrollView {
                VStack {
                    ForEach(ListItem.allCases, id: \.self) { item in
                        NavigationLink {
                            switch item {
                            case .chat:
                                ChattingRoomView(travel: travel)
                            case .editDate:
                                DateManagementView(
                                    travel: travelDetailStore.travel,
                                    paymentDates: paymentStore.paymentDates, 
                                    entryViewtype: .more
                                )
                                .environmentObject(travelDetailStore)
                            case .mamberManagement:
                                MemberManagementView(
                                    paymentsOfType: paymentStore.payments, 
                                    travel: travel,
                                    entryViewtype: .more
                                )
                                    .environmentObject(travelDetailStore)
                            case .settledAccount:
                                SettledAccountView(
                                    entryViewtype: .more
                                )
                                    .environmentObject(travelDetailStore)
                            }
                        } label: {
                            MoreListCell(item: item)
                        }
                        .listRowSeparator(.hidden, edges: /*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    }
                    Spacer()
                }
            }
            Spacer()
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
        }
        .onAppear {
            travelDetailStore.listenTravelDate()
        }
        .onDisappear {
            travelDetailStore.stoplistening()
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image("arrow_back")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
                
            }
            ToolbarItem(placement: .principal) {
                Text("더보기")
                    .font(.title05)
                    .foregroundColor(Color.systemBlack)
            }
        }
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
    NavigationStack {
        MoreView(travel: .sampletravel)
            .environmentObject(UserTravelStore())
            .environmentObject(TabViewStore.shared)
            .environmentObject(TravelDetailStore(travel: TravelCalculation.sampletravel))
            .environmentObject(PaymentStore(travel: TravelCalculation.sampletravel))
    }
}
