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
        Section {
            ForEach(paymentStore.payments) { payment in
                NavigationLink {
                    EditPaymentView(payment: payment, travelCalculation: $travelCalculation, paymentStore: paymentStore)
                        .navigationTitle("지출 항목 수정")
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack{
                        Image(payment.type.getImageString(type: .badge))
                            .resizable()
                            .frame(width: 40, height: 40)
                        VStack(alignment: .leading, content: {
                            
                            Text(payment.content)
                                .foregroundStyle(Color.black)
                            HStack {
                                if payment.participants.count == 1 {
                                    Image("user-single-neutral-male-4")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                }
                                else if payment.participants.count > 1 {
                                    Image("user-single-neutral-male-4-1")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                }
                                Text("\(payment.participants.count)명")
                                    .foregroundStyle(Color(hex: "858899"))
                            }
                        })
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("\(payment.payment)원")
                                .foregroundStyle(Color.black)
                            if payment.participants.isEmpty {
                                Text("\(payment.payment)원")
                                    .foregroundStyle(Color(hex: "858899"))
                            }
                            else {
                                Text("\(payment.payment / payment.participants.count)원")
                                    .foregroundStyle(Color(hex: "858899"))
                            }
                            
                        }
                        
                    }
                }
            }
            .onDelete(perform: { indexSet in
                paymentStore.deletePayment(idx: indexSet)
            })
        }
    }
}

