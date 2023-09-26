//
//  AddPaymentSheetView.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/25.
//

import SwiftUI

struct AddPaymentSheet: View {
    @ObservedObject var paymentStore: PaymentStore
    @Binding var isShowingAddPaymentSheetView: Bool
    
    @State private var expandDetails: String = ""
    @State private var priceString: String = ""
    @State private var selectedCategory: Payment.PaymentType = .transportation
    @State private var isVisibleCategorySelectPicker = false
    @State private var category: String = "교통/숙박/관광/식비/기타"
    
    var body: some View {
        VStack {
            Text("지출 항목 추가")
                .bold()
            
            HStack {
                Text("분류")
                Spacer()
                
                if isVisibleCategorySelectPicker {
                    Picker(selection: $selectedCategory, label: Text("Category")) {
                        ForEach(Payment.PaymentType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Button(action: { isVisibleCategorySelectPicker = false; category = selectedCategory.rawValue }, label: {
                        Text("선택")
                    })
                }
                else {
                    Button(action: {isVisibleCategorySelectPicker = true}, label: {
                        Text(category)
                            .foregroundStyle(.gray)
                    })
                    
                }
            }
            .padding()
            
            HStack {
                Text("지출 내역")
                TextField("지출 내역을 입력하세요", text: $expandDetails)
            }
            .padding()
            
            HStack {
                Text("결제 금액")
                Spacer()
                TextField("결제 금액을 입력하세요", text: $priceString)
                    .keyboardType(.numberPad)
                Text("원")
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
    AddPaymentSheet(paymentStore: PaymentStore(travelCalculationId: ""), isShowingAddPaymentSheetView: .constant(true))
    
}
