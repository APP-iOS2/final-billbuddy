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
    @EnvironmentObject private var settlementExpensesStore: SettlementExpensesStore

    @State private var isShowingDeletePayment: Bool = false
    @State private var isUpdated: Bool = false
    
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
                        Image(.userSingleSvg)
                            .resizable()
                            .frame(width: 18, height: 18)
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
                // FIXME: 해당 data가 아닌 제일 마지막 payment 삭제
                Button(role: .destructive) {
                    Task {
                        await paymentStore.deletePayment(payment: payment)
                        settlementExpensesStore.setSettlementExpenses(payments: paymentStore.payments, members: travelDetailStore.travel.members)
                    }
//                    isShowingDeletePayment = true
                } label: {
                    Text("삭제")
                }
                .frame(width: 88)
                .buttonStyle(.plain)
                .alert(isPresented: $isShowingDeletePayment) {
                    return Alert(title: Text("삭제하시겠습니까?"), primaryButton: .destructive(Text("네"), action: {
                        Task {
                            await paymentStore.deletePayment(payment: payment)
                        }
                    }), secondaryButton: .cancel(Text("아니오")))
                }
                
                NavigationLink {
                    PaymentManageView(mode: .edit, payment: payment, travelCalculation: travelDetailStore.travel, isUpdated: $isUpdated)
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

