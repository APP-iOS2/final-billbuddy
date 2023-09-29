//
//  AddPaymentSheetView.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/25.
//

import SwiftUI

struct AddPaymentView: View {
    @ObservedObject var paymentStore: PaymentStore
    @State var startDate: Double
    @State var endDate: Double
    
    @State private var expandDetails: String = ""
    @State private var priceString: String = ""
    @State private var headCountString: String = ""
    @State private var selectedCategory: Payment.PaymentType = .transportation
    @State private var isSelectedCategory = false
    @State private var isVisibleCategorySelectPicker = false
    @State private var category: String = "교통/숙박/관광/식비/기타"
    @State private var paymentDate: Date = Date.now
    
    var body: some View {
        VStack {
            Text("지출 항목 추가")
                .font(.headline)
                .padding()
            
            SubPaymentView(startDate: startDate, endDate: endDate, expandDetails: $expandDetails, priceString: $priceString, headCountString: $headCountString, selectedCategory: $selectedCategory, category: $category, paymentDate: $paymentDate)
            
            Button(action: {
                let newPayment =
                Payment(type: selectedCategory, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: "", latitude: 0, longitude: 0), participants: [], paymentDate: paymentDate.timeIntervalSince1970)
                paymentStore.addPayment(newPayment: newPayment)
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
        
        
    }
}

#Preview {
    AddPaymentView(paymentStore: PaymentStore(travelCalculationId: "4eB3HvBvH6jXYDLu9irl"), startDate: 0, endDate: 0)
    
}
