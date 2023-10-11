//
//  PaymentMainView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/10/23.
//

import SwiftUI

struct PaymentMainView: View {
    
    
    @ObservedObject var paymentStore: PaymentStore
    @ObservedObject var memberStore: MemberStore
    
    var userTravel: UserTravel
    
    @State var isShowingDateSheet: Bool = false
    @State var selectedDate: Double = 0
    
    var body: some View {
        VStack{
            HStack {
                Button {
                    isShowingDateSheet = true
                } label: {
                    if selectedDate == 0 {
                        Text("전체")
                            .font(.custom("Pretendard-Semibold", size: 16))
                            .foregroundStyle(.black)
                        Image("expand_more")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    
                    else {
                        Text(selectedDate.toDate().dateWeekYear)
                            .font(.custom("Pretendard-Semibold", size: 16))
                            .foregroundStyle(.black)
                        Text("\(selectedDate.howManyDaysFromStartDate(startDate: userTravel.startDate))일차")
                            .font(.custom("Pretendard-Semibold", size: 14))
                            .foregroundStyle(Color(hex: "858899"))
                        Image("expand_more")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                Spacer()
            }
            .padding()
            .sheet(isPresented: $isShowingDateSheet, content: {
                DateSheet(selectedDate: $selectedDate, userTravel: userTravel)
                    .presentationDetents([.fraction(0.4)])
            })
            .frame(height: 52)
            .onChange(of: selectedDate, perform: { date in
                if selectedDate == 0 {
                    paymentStore.fetchAll()
                }
                else {
                    paymentStore.fetchDate(date: date)
                }
            })
            .onAppear {
                if selectedDate == 0 {
                    paymentStore.fetchAll()
                }
                else {
                    paymentStore.fetchDate(date: selectedDate)
                }
            }
            
            
            GroupBox {
                HStack {
                    VStack(alignment: .leading, content: {
                        HStack{
                            Text("총 지출")
                                .font(.custom("Pretendard-Medium", size: 14))
                                .foregroundStyle(Color(hex: "858899"))
                            Image("chevron_right")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        Text("₩0")
                            .font(.custom("Pretendard-Semibold", size: 16))
                    })
                    
                    Spacer()
                    
                    NavigationLink {
                        Text("정산 뷰")
                    } label: {
                        Text("정산하기")
                    }
                }
                
            }
            .frame(height: 80)
            .padding()
            
            HStack {
                Button(action: {
                    
                }, label: {
                    Text("전체내역")
                    Image("expand_more")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
                
                Spacer()
                Text("편집")
            }
            .padding()
            
            Divider()
            
            HStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        PaymentListView(paymentStore: paymentStore, memberStore: memberStore, userTravel: userTravel)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            
            Spacer()
            
            GroupBox {
                NavigationLink {
                    AddPaymentView(paymentStore: paymentStore, memberStore: memberStore, userTravel: userTravel)
                        .navigationTitle("지출 항목 추가")
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack {
                        Spacer()
                        Image("Group 1171275314")
                            .resizable()
                            .frame(width: 28, height: 28)
                        
                        Text("지출 내역 추가")
                        
                        Spacer()
                    }
                }
            }
            .padding()
        }
    }
}
