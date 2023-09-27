//
//  PaymentListView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI


struct PaymentListView: View {
    @ObservedObject var paymentStore: PaymentStore
    
    @State private var isShowingEditPaymentSheet = false
    
    var body: some View {
        Section {
            ForEach(paymentStore.payments) { payment in
                NavigationLink {
                    EditPaymentView(payment: payment, isShowingEditPaymentSheet: $isShowingEditPaymentSheet)
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
        }
    }
}
