//
//  DetailMainView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/9/23.
//

import SwiftUI

struct DetailMainView: View {
    
    @ObservedObject var paymentStore: PaymentStore
    @ObservedObject var memberStore: MemberStore
    
    var userTravel: UserTravel
    
    enum Mode {
        case payment
        case map
    }
    
    @State var mode: Mode = .payment
    
    @State var isPayment: Bool = true
    
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    mode = .payment
                    isPayment = true
                } label: {
                    Text("내역")
                }
                .tint(isPayment ? .accentColor: .black)
                .padding()
                
                Spacer()
                
                Button {
                    mode = .map
                    isPayment = false
                } label: {
                    Text("지도")
                }
                .tint(isPayment ? .black: .accentColor)
                .padding()

            }
            .padding()
            
            if isPayment {
                PaymentMainView(paymentStore: paymentStore, memberStore: memberStore, userTravel: userTravel)
            }
            else {
                Text("지도 뷰")
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailMainView(paymentStore: PaymentStore(travelCalculationId: "4eB3HvBvH6jXYDLu9irl"), memberStore: MemberStore(travelCalculationId: "4eB3HvBvH6jXYDLu9irl"), userTravel: UserTravel(travelId: "4eB3HvBvH6jXYDLu9irl", travelName: "신나는 유럽여행", startDate: 1675186400, endDate: 1681094400))
    }
}
