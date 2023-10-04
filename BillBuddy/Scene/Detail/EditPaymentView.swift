//
//  EditPaymentSheet.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/27.
//

import SwiftUI

struct EditPaymentView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var payment: Payment
    @ObservedObject var paymentStore: PaymentStore
    @ObservedObject var memberStore: MemberStore
    var travelCalculation: TravelCalculation
    
    @State private var expandDetails: String = ""
    @State private var priceString: String = ""
    @State private var headCountString: String = ""
    @State private var selectedCategory: Payment.PaymentType = .transportation
    @State private var category: String = "교통/숙박/관광/식비/기타"
    @State private var paymentDate: Date = Date()
    
    var body: some View {
        VStack {
            
            List {
                SubPaymentView(travelCalculation: travelCalculation, expandDetails: $expandDetails, priceString: $priceString, headCountString: $headCountString, selectedCategory: $selectedCategory, category: $category, paymentDate: $paymentDate)
                    .onAppear {
                        category = payment.type.rawValue
                        selectedCategory = payment.type
                        expandDetails = payment.content
                        priceString = String(payment.payment)
                        paymentDate = payment.paymentDate.toDate()
                    }
                EditPaymentMemberView(payment: $payment, memberStore: memberStore)
//                AddPaymentMemberView(memberStore: memberStore)
            }
            
            Button(action: {
                let newPayment = Payment(id: payment.id, type: selectedCategory, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: "", latitude: 0, longitude: 0), participants: [], paymentDate: paymentDate.timeIntervalSince1970)
                paymentStore.editPayment(payment: newPayment)
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Spacer()
                    Text("수정하기")
                        .bold()
                    Spacer()
                }
                .padding()
            })
            .buttonStyle(.borderedProminent)
            .padding()
            
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                })
            }
            
        })
        .onAppear {
            paymentStore.fetchAll()
        }
        
    }
        
}


