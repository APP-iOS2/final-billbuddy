//
//  AddPaymentSheetView.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/25.
//

import SwiftUI

struct AddPaymentSheetView: View {
    @ObservedObject var paymentStore: PaymentStore
    @Binding var isShowingAddPaymentSheetView: Bool
    
    @State private var expandDetails: String = ""
    @State private var priceString: String = ""
    @State private var selectedCategory = "교통"
    
    var body: some View {
        VStack {
            Text("지출 항목 추가")
                .bold()
            
            HStack {
                Text("분류")
                Picker(selection: $selectedCategory, label: Text("Category")) {
                    Text("교통").tag(1)
                    Text("숙박").tag(2)
                    Text("관광").tag(3)
                    Text("식비").tag(4)
                    Text("기타").tag(5)
                }
                .pickerStyle(.wheel)
            }
            .padding()
            
            HStack {
                Text("지출 내역")
                TextField("지출 내역을 입력하세요", text: $expandDetails)
            }
            .padding()
            
            HStack {
                Text("결제 금액")
                TextField("결제 금액을 입력하세요", text: $priceString)
                    .keyboardType(.numberPad)
            }
            .padding()
            
            HStack {
                Text("위치")
                Spacer()
                Text("추후")
            }
            .padding()
            
            Button(action: {
                isShowingAddPaymentSheetView = false
                let newPayment = Payment(type: .transportation, content: expandDetails, payment: Int(priceString) ?? 0, address: "", x: 0, y: 0, participants: [])
                paymentStore.addPayment(newPayment: newPayment)
            }, label: {
                Text("완료")
            })

            
            
        }
        
        
    }
}

#Preview {
    NavigationStack {
        AddPaymentSheetView(paymentStore: PaymentStore(travelCalculationId: ""), isShowingAddPaymentSheetView: .constant(true))
    }
}
