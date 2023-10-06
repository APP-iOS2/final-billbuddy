//
//  AddPaymentSheetView.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/25.
//

import SwiftUI

struct AddPaymentView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var paymentStore: PaymentStore
    @ObservedObject var memberStore: MemberStore
    var travelCalculation: TravelCalculation
    
    @State private var expandDetails: String = ""
    @State private var priceString: String = ""
    @State private var headCountString: String = ""
    @State private var selectedCategory: Payment.PaymentType = .transportation
    @State private var category: String = "교통/숙박/관광/식비/기타"
    @State private var paymentDate: Date = Date()
    @State private var newMembers: [Member] = []
    
    var divider: some View {
        Divider()
            .padding(.leading, 10)
            .padding(.trailing, 10)
    }
    
    var body: some View {
        VStack {
            List {
                SubPaymentView(travelCalculation: travelCalculation, expandDetails: $expandDetails, priceString: $priceString, headCountString: $headCountString, selectedCategory: $selectedCategory, category: $category, paymentDate: $paymentDate)
                
                AddPaymentMemberView(newMembers: $newMembers, memberStore: memberStore)
            }
            
            // 위치
            
            Button(action: {
                var participants: [Payment.Participant] = []
                
                for m in newMembers {
                    participants.append(Payment.Participant(memberId: m.id ?? "", payment: m.payment))
                }
                
                let newPayment =
                Payment(type: selectedCategory, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: "", latitude: 0, longitude: 0), participants: participants, paymentDate: paymentDate.timeIntervalSince1970)
                paymentStore.addPayment(newPayment: newPayment)
                presentationMode.wrappedValue.dismiss()
                
            }, label: {
                HStack {
                    Spacer()
                    Text("추가하기")
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
    }
}

//#Preview {
//    AddPaymentView(paymentStore: PaymentStore(travelCalculationId: "4eB3HvBvH6jXYDLu9irl"), travelCalculation: trav)
//
//}
