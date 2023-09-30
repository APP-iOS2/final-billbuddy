//
//  SubPaymentView.swift
//  BillBuddy
//
//  Created by 김유진 on 9/29/23.
//

import SwiftUI

struct AddPaymentMemberView: View {
    @State private var newMembers: [Member] = []
    @ObservedObject var memberStore: MemberStore
    
    @State private var isShowingAddSheet: Bool = false
    
    var body: some View {
        Section {
            HStack {
                Text("인원")
                    .bold()
                Spacer()
                Button(action: {
                    isShowingAddSheet = true
                }, label: {
                    Text("추가하기")
                })
                
            }
            .padding()
            .sheet(isPresented: $isShowingAddSheet, content: {
                
                List(memberStore.members) { member in
                    Text(member.name)
                }
                .onAppear {
                    memberStore.fetchAll()
                }
            })
            
        }
    }
}

struct SubPaymentView: View {
    
    var travelCalculation: TravelCalculation
    
    @Binding var expandDetails: String
    @Binding var priceString: String
    @Binding var headCountString: String
    @Binding var selectedCategory: Payment.PaymentType
    @Binding var category: String
    @Binding var paymentDate: Date
    
    @State var isSelectedCategory: Bool = false
    @State var isVisibleCategorySelectPicker: Bool = false
    
    var divider: some View {
        Divider()
            .padding(.leading, 10)
            .padding(.trailing, 10)
    }
    
    var body: some View {
        Group {
            Section {
                DatePicker(selection: $paymentDate, in: travelCalculation.startDate.toDate()...travelCalculation.endDate.toDate(), displayedComponents: .date, label: {
                    Text("일자")
                        .bold()
                })
                .padding()
            }
            
            Section {
                HStack {
                    Text("분류")
                        .bold()
                    Spacer()
                    
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
                .padding()
                .onAppear {
                    if category != "교통/숙박/관광/식비/기타" {
                        isSelectedCategory = true
                    }
                }
                .sheet(isPresented: $isVisibleCategorySelectPicker, content: {
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
                    
                    .presentationDetents([.fraction(0.3)])
                })
                
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

//
//#Preview {
//    SubPaymentView()
//}
