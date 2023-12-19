//
//  PaymentListView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI


struct PaymentListView: View {
    @ObservedObject var paymentStore: PaymentStore
    @EnvironmentObject private var travelDetailStore: TravelDetailStore
    @EnvironmentObject private var settlementExpensesStore: SettlementExpensesStore
    
    @State private var isShowingDeletePayment: Bool = false
    @State private var selectedPayment: Payment?
    
    @Binding var isEditing: Bool
    @Binding var forDeletePayments: [Payment]
    
    var body: some View {
        ForEach(paymentStore.filteredPayments) { payment in
            HStack(spacing: 12){
                if isEditing {
                    if forDeletePayments.isEmpty {
                        Button {
                            forDeletePayments.append(payment)
                        } label: {
                            Image(.formCheckInputRadio)
                        }
                    }
                    
                    else if let index = forDeletePayments.firstIndex(where: { $0.id == payment.id }) {
                        Button {
                            forDeletePayments.remove(at: index)
                        } label: {
                            Image(.formCheckedInputRadio)
                        }
                    }
                    
                    else {
                        Button {
                            forDeletePayments.append(payment)
                        } label: {
                            Image(.formCheckInputRadio)
                        }
                    }
                }
                
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
                
                if !isEditing {
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
                
            }
            .padding(.leading, 16)
            .padding(.trailing, 24)
            .swipeActions {
                if travelDetailStore.travel.isPaymentSettled == false {
                    Button(role: .destructive) {
                        selectedPayment = payment
                        isShowingDeletePayment = true
                    } label: {
                        Text("삭제")
                    }
                    .frame(width: 88)
                    .buttonStyle(.plain)
                    
                    
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
            .onChange(of: isEditing) { newValue in
                if isEditing == false {
                    forDeletePayments = []
                }
            }
            
        }
        .alert(isPresented: $isShowingDeletePayment) {
            return Alert(title: Text(PaymentAlertText.paymentDelete), primaryButton: .destructive(Text("네"), action: {
                Task {
                    if let payment = selectedPayment {
                        await paymentStore.deletePayment(payment: payment)
                        settlementExpensesStore.setSettlementExpenses(payments: paymentStore.payments, members: travelDetailStore.travel.members)
                    }
                }
            }), secondaryButton: .cancel(Text("아니오")))
        }
        .listRowInsets(nil)
        
    }
}

