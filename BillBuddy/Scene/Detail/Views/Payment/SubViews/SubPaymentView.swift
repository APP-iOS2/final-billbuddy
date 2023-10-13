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
    
    var body: some View {
        Group {
            Section {
                // TODO: 이 부분 한국식으로 어떻게할지 고민
                DatePicker(selection: $paymentDate, in: travelCalculation.startDate.toDate()...travelCalculation.endDate.toDate(), displayedComponents: .date, label: {
                    Text("일자")
                        .font(.custom("Pretendard-Bold", size: 14))
                })
                .padding(.leading, 16)
                .padding(.top, 16)
                .padding(.bottom, 16)
            }
            
            Section {
                
                HStack{
                    Text("분류")
                        .font(.custom("Pretendard-Bold", size: 14))
                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.top, 16)
                .padding(.bottom, 20)
                
                HStack {
                    Spacer()
                    SelectCategoryView(mode: .category, selectedCategory: $selectedCategory)
                    Spacer()
                }
                .padding(.bottom, 30)
                .listRowSeparator(.hidden)
            }
            
            Section {
                
                HStack {
                    Text("내용")
                        .font(.custom("Pretendard-Bold", size: 14))
                    TextField("내용을 입력해주세요", text: $expandDetails)
                        .multilineTextAlignment(.trailing)
                        .font(.custom("Pretendard-Medium", size: 14))
                }
                .padding(.leading, 16)
                .padding(.top, 16)
                .padding(.bottom, 16)
            }
            
            Section {
                
                HStack {
                    Text("결제금액")
                        .font(.custom("Pretendard-Bold", size: 14))
                    Spacer()
                    
                    TextField("결제금액을 입력해주세요", text: $priceString)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .font(.custom("Pretendard-Medium", size: 14))
                }
                .padding(.leading, 16)
                .padding(.top, 16)
                .padding(.bottom, 16)
            }
            
        }
    }
}

//#Preview {
//    SubPaymentView(userTravel: UserTravel(travelId: "", travelName: "신나는 유럽 여행", startDate: 0, endDate: 0), expandDetails: .constant(""), priceString: .constant(""), headCountString: .constant(""), selectedCategory: .constant(.accommodation), category: .constant(""), paymentDate: .constant(Date()), isSelectedCategory: false, isVisibleCategorySelectPicker: false)
//}
