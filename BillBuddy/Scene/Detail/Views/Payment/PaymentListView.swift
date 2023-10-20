//
//  PaymentListView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI


struct PaymentListView: View {
    @ObservedObject var paymentStore: PaymentStore
    @ObservedObject var travelDetailStore: TravelDetailStore
    
    var body: some View {
        
        ForEach(paymentStore.filteredPayments) { payment in
            HStack(spacing: 12){
                Image(payment.type.getImageString(type: .badge))
                    .resizable()
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading, spacing: 0, content: {
                    
                    Text(payment.content)
                        .font(.body03)
                        .foregroundStyle(Color.black)
                    HStack(spacing: 4) {
                        // MARK: Rendering 이미지가 전체를 뒤엎음
                        if payment.participants.count == 1 {
                            Image("user-single-neutral-male-4")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 18, height: 18)
                                .foregroundStyle(Color.gray600)
                            
                        }
                        else if payment.participants.count > 1 {
                            Image("user-single-neutral-male-4-1")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 18, height: 18)
                                .foregroundStyle(Color.gray600)
                        }
                        Text("\(payment.participants.count)명")
                            .font(.body04)
                            .foregroundStyle(Color.gray600)
                    }
                })
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("₩\(payment.payment)")
                        .foregroundStyle(Color.black)
                        .font(.body02)
                    
                    if payment.participants.isEmpty {
                        Text("₩\(payment.payment)")
                            .foregroundStyle(Color.gray600)
                            .font(.caption02)
                    }
                    else {
                        Text("₩\(payment.payment / payment.participants.count)")
                            .foregroundStyle(Color.gray600)
                            .font(.caption02)
                    }
                    
                }
                
            }
            .padding(.leading, 16)
            .padding(.trailing, 24)
            .swipeActions {
                Button(role: .destructive) {
                    paymentStore.deletePayment(payment: payment)
                } label: {
                    Text("삭제")
                }
                .frame(width: 88)
                
                NavigationLink {
                    PaymentManageView(mode: .edit, payment: payment, travelCalculation: travelDetailStore.travel)
                        .environmentObject(paymentStore)
                } label: {
                    Text("수정")
                }
                .frame(width: 88)
                .background(Color.gray500)
            }
        }
        .listRowInsets(nil)
        
    }
}

