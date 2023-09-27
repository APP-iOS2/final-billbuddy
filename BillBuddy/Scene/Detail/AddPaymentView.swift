//
//  AddPaymentSheetView.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/25.
//

import SwiftUI

struct AddPaymentView: View {
    @ObservedObject var paymentStore: PaymentStore
    
    @State private var expandDetails: String = ""
    @State private var priceString: String = ""
    @State private var numString: String = ""
    @State private var selectedCategory: Payment.PaymentType = .transportation
    @State private var isSelectedCategory = false
    @State private var isVisibleCategorySelectPicker = false
    @State private var category: String = "교통/숙박/관광/식비/기타"
    
    var body: some View {
        VStack {
            Text("지출 항목 추가")
                .font(.headline)
                .padding()
            
            HStack {
                Text("분류")
                    .bold()
                Spacer()
                
                if isVisibleCategorySelectPicker {
                    Picker(selection: $selectedCategory, label: Text("Category")) {
                        ForEach(Payment.PaymentType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Button(action: { isVisibleCategorySelectPicker = false
                        category = selectedCategory.rawValue
                        isSelectedCategory = true
                    }, label: {
                        Text("선택")
                    })
                }
                else {
                    Button(action: {
                        isVisibleCategorySelectPicker = true
                    }, label: {
                        if isSelectedCategory {
                            Text(category)
                                .foregroundStyle(.black)
                        }
                        else {
                            Text(category)
                                .foregroundStyle(.gray)
                        }
                    })
                    
                }
            }
            .padding()
            
            Divider()
                .padding(.leading, 10)
                .padding(.trailing, 10)
            
            HStack {
                Text("내용")
                    .bold()
                TextField("내용을 입력해주세요", text: $expandDetails)
                    .multilineTextAlignment(.trailing)
            }
            .padding()
            
            Divider()
                .padding(.leading, 10)
                .padding(.trailing, 10)
            
            HStack {
                Text("인원")
                    .bold()
                TextField("인원을 입력해주세요", text: $numString)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }
            .padding()
            
            Divider()
                .padding(.leading, 10)
                .padding(.trailing, 10)
            
            HStack {
                Text("결제금액")
                    .bold()
                Spacer()

                TextField("결제금액을 입력해주세요", text: $priceString)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }
            .padding()
            
            Divider()
                .padding(.leading, 10)
                .padding(.trailing, 10)
            
            HStack {
                Text("위치")
                    .bold()
                Spacer()
                Text("추후")
            }
            .padding()
            
            Button(action: {
                let newPayment =
                Payment(type: selectedCategory, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: "", latitude: 0, longitude: 0), participants: [])
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
    AddPaymentView(paymentStore: PaymentStore(travelCalculationId: "4eB3HvBvH6jXYDLu9irl"))
    
}
