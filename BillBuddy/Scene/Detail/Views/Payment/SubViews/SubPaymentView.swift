//
//  SubPaymentView.swift
//  BillBuddy
//
//  Created by 김유진 on 9/29/23.
//

import SwiftUI

struct SubPaymentView: View {
    
    @Binding var travelCalculation: TravelCalculation
    
    @Binding var expandDetails: String
    @Binding var priceString: String
    @Binding var selectedCategory: Payment.PaymentType?
    @Binding var paymentDate: Date
    
    var divider: some View {
        Divider()
            .padding(.leading, 10)
            .padding(.trailing, 10)
    }
    
    var body: some View {
        Group {
            
            Section {
                // TODO: 이 부분 한국식으로 어떻게할지 고민
                DatePicker(selection: $paymentDate, in: travelCalculation.startDate.toDate()...travelCalculation.endDate.toDate(), displayedComponents: .date, label: {
                    Text("일자")
                        .bold()
                })
                .padding()
            }
            
            Section {
                
                HStack{
                    Text("분류")
                        .bold()
                    Spacer()
                }
                .padding()
                
                HStack {
                    ForEach(Payment.PaymentType.allCases, id:\.self) { type in
                        Button(action: {
                                selectedCategory = type
                        }, label: {
                            VStack {
                                if let selected = selectedCategory {
                                    if selected == type {
                                        Image(type.getImageString(type: .thin))
                                            .renderingMode(.template)
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundStyle(Color.primary)
                                        Text(type.rawValue)
                                            .font(.custom("Pretendard-Medium", size: 12))
                                            .foregroundStyle(Color.primary)
                                            
                                    }
                                    else {
                                        Image(type.getImageString(type: .thin))
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                        Text(type.rawValue)
                                            .font(.custom("Pretendard-Medium", size: 12))
                                            .foregroundStyle(Color(hex: "A9ABB8"))
                                        
                                    }
                                }
                                else {
                                    Image(type.getImageString(type: .thin))
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    Text(type.rawValue)
                                        .font(.custom("Pretendard-Medium", size: 12))
                                        .foregroundStyle(Color(hex: "A9ABB8"))
                                    
                                }
                                
                                
                            }
                            .padding()
                        })
                        .buttonStyle(.plain)
                    }
                }
                
            }
            
            Section {
                
                HStack {
                    Text("내용")
                        .bold()
                    TextField("내용을 입력해주세요", text: $expandDetails)
                        .multilineTextAlignment(.trailing)
                }
                .padding()
            }
            
            Section {
                
                HStack {
                    Text("결제금액")
                        .bold()
                    Spacer()
                    
                    TextField("결제금액을 입력해주세요", text: $priceString)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                .padding()
            }
            
        }
    }
}

//#Preview {
//    SubPaymentView(userTravel: UserTravel(travelId: "", travelName: "신나는 유럽 여행", startDate: 0, endDate: 0), expandDetails: .constant(""), priceString: .constant(""), headCountString: .constant(""), selectedCategory: .constant(.accommodation), category: .constant(""), paymentDate: .constant(Date()), isSelectedCategory: false, isVisibleCategorySelectPicker: false)
//}
