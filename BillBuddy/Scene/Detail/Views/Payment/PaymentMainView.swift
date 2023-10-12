//
//  PaymentMainView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/10/23.
//

import SwiftUI

struct PaymentMainView: View {
    
    @Binding var travelCalculation: TravelCalculation
    @ObservedObject var paymentStore: PaymentStore
    
    @State var isShowingDateSheet: Bool = false
    @State var selectedDate: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            
            /// 2023년 9월 21일 1일차
            date
                .frame(height: 52)
            
            /// 총 지출 >
            Group {
                HStack {
                    VStack(alignment: .leading, spacing: 4, content: {
                        HStack(spacing: 0) {
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
                    .padding(.top, 18)
                    .padding(.leading, 15)
                    .padding(.bottom, 15)
                    
                    Spacer()
                    
                    NavigationLink {
                        Text("정산 뷰")
                    } label: {
                        Text("정산하기")
                            .font(.custom("Pretendard-Medium", size: 14))
                            .foregroundStyle(Color(hex: "858899"))
                    }
                    
                    .frame(width: 71, height: 30, alignment: .center)
                    .background {
                        RoundedRectangle(cornerRadius: 21)
                            .fill(Color.white)
                    }
                    .padding(.trailing, 18)
                }
            }
            .frame(height: 80)
            .background {
                RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "F7F7FA"))
            }
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .padding(.bottom, 32)
            
            HStack(spacing: 0) {
                Button(action: {
                    
                }, label: {
                    Text("전체내역")
                        .font(.custom("Pretendard-Medium", size: 14))
                        .foregroundStyle(Color(hex: "858899"))
                    Image("expand_more")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
                
                Spacer()
                
                Text("편집")
                    .font(.custom("Pretendard-Medium", size: 14))
                    .foregroundStyle(Color(hex: "858899"))
            }
            .padding(.leading, 17)
            .padding(.trailing, 20)
            .padding(.bottom, 9)
            
            Divider()
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .padding(.bottom, 16)
            
            paymentList
            
            Spacer()
            
            
        }
    }
    
    var paymentList: some View {
        ScrollView {
            VStack {
                PaymentListView(travelCalculation: $travelCalculation, paymentStore: paymentStore)
                    .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            
            Group {
                NavigationLink {
                    AddPaymentView(travelCalculation: $travelCalculation, paymentStore: paymentStore)
                        .navigationTitle("지출 항목 추가")
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 12) {
                        Spacer()
                        Image("add payment")
                            .resizable()
                            .frame(width: 28, height: 28)
                        
                        Text("지출 내역 추가")
                            .font(.custom("Pretendard-Medium", size: 14))
                            .foregroundStyle(Color(hex: "858899"))
                        
                        Spacer()
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 12)
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "F0F0F5"), lineWidth: 1)
                    
            }
            .padding(.leading, 16)
            .padding(.trailing, 16)
        }
    }
    
    var date: some View {
        
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
                    Text("\(selectedDate.howManyDaysFromStartDate(startDate: travelCalculation.startDate))일차")
                        .font(.custom("Pretendard-Semibold", size: 14))
                        .foregroundStyle(Color(hex: "858899"))
                    Image("expand_more")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.leading, 16)
            .padding(.bottom, 13)
            .padding(.top, 15)
            
            
            Spacer()
        }
        
        .sheet(isPresented: $isShowingDateSheet, content: {
            DateSheet(selectedDate: $selectedDate, startDate: travelCalculation.startDate, endDate: travelCalculation.endDate)
                .presentationDetents([.fraction(0.4)])
        })

        .onChange(of: selectedDate, perform: { date in
            // MARK: 1번만 fetch되게 하는 방법이 없을지 ,,
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
    }
}
