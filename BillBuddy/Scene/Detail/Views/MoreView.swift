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
    case spendingList
    
    var itemName: String {
        switch self {
        case .chat:
            "채팅"
        case .editDate:
            "지도"
        case .mamberManagement:
            "인원관리"
        case .spendingList:
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
        case .spendingList:
            "script-2-18"
        }
    }
}

// 리스트 가 옆으로 밀리는 버그가 있음
struct MoreView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var travelCalculation: TravelCalculation
    
    var body: some View {
        VStack {
            List(ListItem.allCases, id:\.self) { item in
                NavigationLink {
                    switch item {
                    case .chat:
                        SpendingListView()
                    case .editDate:
                        SpendingListView()
                    case .mamberManagement:
                        MemberManagementView(sampleMemeberStore: SampleMemeberStore(travel: travelCalculation))
                    case .spendingList:
                        SpendingListView()
                    }
                } label: {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(item.itemImageString)
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 12)
                            Text(item.itemName)
                                .font(Font.body04)
                        }
                    }
                    .foregroundStyle(Color.gray800)
                    .frame(height: 16 + 16 + 24)
                    .padding([.leading, .trailing], 24)
                }
            }
            .listStyle(.plain)
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
