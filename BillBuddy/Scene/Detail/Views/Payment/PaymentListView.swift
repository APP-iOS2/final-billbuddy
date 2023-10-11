//
//  PaymentListView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI


struct PaymentListView: View {
    @ObservedObject var paymentStore: PaymentStore
    @ObservedObject var memberStore: MemberStore
    var userTravel: UserTravel
    
    var body: some View {
        Section {
            ForEach(paymentStore.payments) { payment in
                NavigationLink {
                    EditPaymentView(payment: payment, paymentStore: paymentStore, memberStore: memberStore, userTravel: userTravel)
                        .navigationTitle("지출 항목 수정")
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack{
                        ParticipantProfileView(payment: payment, memberStore: memberStore)
                            .frame(height: 30)
                        VStack(alignment: .leading, content: {
                            
                            Text("\(payment.payment)")
                                .bold()
                            Text(payment.content)
                                .tint(.gray)
                        })
                    }
                }
            }
            .onDelete(perform: { indexSet in
                paymentStore.deletePayment(idx: indexSet)
            })
        }
        .onAppear {
            memberStore.fetchAll()
        }
    }
}

//#Preview {
//    PaymentListView(paymentStore: PaymentStore(travelCalculationId: "4eB3HvBvH6jXYDLu9irl"), memberStore: MemberStore(travelCalculationId: "4eB3HvBvH6jXYDLu9irl"), travelCalculation: TravelCalculation(hostId: "", travelTitle: "유럽", managerId: "", startDate: 0, endDate: 0, updateContentDate: Date(), members: []))
//}
