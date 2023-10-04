//
//  RoomListView.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/26.
//

import SwiftUI

/// 방 메인 -> 나중에 아리님 코드에서 불러오게끔 수정

struct tempRoomListView: View {
    @StateObject var travelCalculationStore: tempTravelCalculationStore = tempTravelCalculationStore()

    
    var body: some View {
        List {
            ForEach(travelCalculationStore.travelCalculations) { travelCalculation in
                NavigationLink {
                    if let id = travelCalculation.id {
                        let paymentStore = PaymentStore(travelCalculationId: id)
                        let memberStore = MemberStore(travelCalculationId: id)
                        
                        DetailMainView(paymentStore: paymentStore, memberStore: memberStore, travelCalculation: travelCalculation)
                            .navigationTitle(travelCalculation.travelTitle)
                            .navigationBarBackButtonHidden()
                    }
                } label: {
                    Text(travelCalculation.travelTitle)
                }
            }
        }
        .onAppear {
            travelCalculationStore.fetchAll()
        }
    }
}

#Preview {
    NavigationStack{
        tempRoomListView()
    }
}
