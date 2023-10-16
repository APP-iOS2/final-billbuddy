//
//  MoreView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/4/23.
//

import SwiftUI

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
            "지도"
        case .mamberManagement:
            "인원관리"
        case .settledAccount:
            "결산"
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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var travelCalculation: TravelCalculation
    
    var body: some View {
        Divider()
            .padding(.bottom, 16)
        VStack {
            ForEach(ListItem.allCases, id:\.self) { item in
                NavigationLink {
                    switch item {
                    case .chat:
                        ChattingRoomView(travel: travelCalculation)
                    case .editDate:
                        SpendingListView()
                    case .mamberManagement:
                        MemberManagementView(sampleMemeberStore: SampleMemeberStore(travel: travelCalculation))
                    case .settledAccount:
                        SettledAccountView()
                    }
                } label: {
                   MoreListCell(item: item)
                }
                .listRowSeparator(.hidden, edges: /*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
            .listStyle(.plain)
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
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
    }
}

#Preview {
    NavigationStack {
        MoreView(travelCalculation: TravelCalculation.sampletravel)
    }
}