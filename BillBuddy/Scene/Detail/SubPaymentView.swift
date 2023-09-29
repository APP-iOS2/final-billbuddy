//
//  SubPaymentView.swift
//  BillBuddy
//
//  Created by 김유진 on 9/29/23.
//

import SwiftUI

struct SubPaymentView: View {
    @State var startDate: Double
    @State var endDate: Double
    
    @Binding var expandDetails: String
    @Binding var priceString: String
    @Binding var headCountString: String
    @Binding var selectedCategory: Payment.PaymentType
    @Binding var category: String
    @Binding var paymentDate: Date
    
    @State var isSelectedCategory: Bool = false
    @State var isVisibleCategorySelectPicker: Bool = false
    
    var body: some View {
        VStack {
            DatePicker(selection: $paymentDate, in: startDate.toDate()...endDate.toDate(), displayedComponents: .date, label: {
                Text("일자")
                    .bold()
            })
            .padding()
            
            Divider()
            
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
                Spacer()
                Text("추후")
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
        }
    }
}

//
//#Preview {
//    SubPaymentView()
//}
