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
                // MARK: Date Picker에서 시간까지 다 받아야할듯 ,, 10분 단위나 ,, 그런 너낌으로 / 아님 순서를 정해줘야함
                
                /// 1 장소에서 2 장소로 이동했는데 2 장소가 먼저인지 1 장소가 먼저인지를 모름 → 시간이든 뭐든 써줘야할거같은데 어떻게할지!!
                /// 1. paymentDate에 끼워넣는다
                /// 2. order를 사용자가 스크롤하면서 할 수 있게해서 순서를 payment에 var order 등으로 생성해서 넣어준다
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
