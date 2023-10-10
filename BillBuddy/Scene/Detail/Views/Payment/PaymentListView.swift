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
                        Image(payment.type.getImageString(type: .badge))
                            .resizable()
                            .frame(width: 40, height: 40)
                        VStack(alignment: .leading, content: {
                            
                            Text(payment.content)
                                .tint(.gray)
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
                            }
                        })
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("\(payment.payment)원")
                            if payment.participants.isEmpty {
                                Text("\(payment.payment)원")
                            }
                            else {
                                Text("\(payment.payment / payment.participants.count)원")
                            }
                            
                        }
                        
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

#Preview {
    PaymentListView(paymentStore: PaymentStore(travelCalculationId: "4eB3HvBvH6jXYDLu9irl"), memberStore: MemberStore(travelCalculationId: "4eB3HvBvH6jXYDLu9irl"), userTravel: UserTravel(travelId: "", travelName: "신나는 유럽 여행", startDate: 0, endDate: 0))
}
