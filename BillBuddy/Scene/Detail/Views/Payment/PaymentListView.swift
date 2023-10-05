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
    var travelCalculation: TravelCalculation
    
    var body: some View {
        Section {
            ForEach(paymentStore.payments) { payment in
                NavigationLink {
                    EditPaymentView(payment: payment, paymentStore: paymentStore, memberStore: memberStore, travelCalculation: travelCalculation)
                        .navigationTitle("지출 항목 수정")
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack{
                        Image(systemName: "square.and.arrow.down.fill")
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
    }
}
