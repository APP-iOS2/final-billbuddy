//
//  EditPaymentSheet.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/27.
//

import SwiftUI

struct EditPaymentView: View {
    @State var payment: Payment
    
    @Binding var isShowingEditPaymentSheet: Bool
    
    @State private var expandDetails: String = ""
    @State private var priceString: String = ""
    @State private var numString: String = ""
    @State private var selectedCategory: Payment.PaymentType = .transportation
    @State private var isVisibleCategorySelectPicker = false
    @State private var category: String = "교통/숙박/관광/식비/기타"
    
    var body: some View {
        VStack {
            Text("지출 항목 수정")
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
                    }, label: {
                        Text("선택")
                    })
                }
                else {
                    Button(action: {
                        isVisibleCategorySelectPicker = true
                    }, label: {
                        Text(category)
                            .foregroundStyle(.black)
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
                isShowingEditPaymentSheet = false

                let newPayment = Payment(id: payment.id, type: selectedCategory, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: "", latitude: 0, longitude: 0), participants: [])
//                PaymentStore.
                //                paymentStore.addPayment(newPayment: newPayment)
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
        .onAppear {
            category = payment.type.rawValue
            selectedCategory = payment.type
            expandDetails = payment.content
//            numString = String(payment.)
            priceString = String(payment.payment)
            
        }
    }
}

#Preview {
    EditPaymentView(payment: Payment(type: .transportation, content: "", payment: 50000, address: Payment.Address(address: "", latitude: 0, longitude: 0), participants: []), isShowingEditPaymentSheet: .constant(true))
}
