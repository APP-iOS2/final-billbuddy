//
//  PaymentListView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI


struct PaymentListView: View {
    @Binding var travelCalculation: TravelCalculation
    @ObservedObject var paymentStore: PaymentStore
    
    var body: some View {
        
        ForEach(paymentStore.payments) { payment in
            PaymentCellView(payment: payment)
                .swipeActions {
                    Button(role: .destructive) {
                        paymentStore.deletePayment(payment: payment)
                    } label: {
                        Text("삭제")
                    }
                    
                    NavigationLink {
                        EditPaymentView(payment: payment, travelCalculation: $travelCalculation, paymentStore: paymentStore)
                            .navigationTitle("지출 항목 수정")
                            .navigationBarBackButtonHidden()
                    } label: {
                        Text("수정")
                    }
                }
        }
        .listRowInsets(nil)
        
    }
}

