//
//  PaymentMainView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/10/23.
//

import SwiftUI


struct PaymentMainView: View {
    
    @Binding var travelCalculation: TravelCalculation
    @Binding var selectedDate: Double
    @ObservedObject var paymentStore: PaymentStore
    
    @State var isShowingSelectCategorySheet: Bool = false
    @State var selectedCategory: Payment.PaymentType?
    
    var body: some View {
        VStack(spacing: 0) {
            header
            paymentList
            Spacer()
        }
    }
    
    var header: some View {
        VStack(spacing: 0) {
            
            /// 총 지출 >
            Group {
                HStack {
                    VStack(alignment: .leading, spacing: 4, content: {
                        HStack(spacing: 0) {
                            NavigationLink {
                                SpendingListView()
                            } label: {
                                Text("총 지출")
                                    .font(.custom("Pretendard-Medium", size: 14))
                                    .foregroundStyle(Color.gray600)
                                Image("chevron_right")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
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
                            .foregroundStyle(Color.gray600)
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
                    .fill(Color.gray050)
            }
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .padding(.bottom, 32)
            
            filteringSection
        }
    }
    
    var paymentList: some View {
        VStack(spacing: 0) {
            List {
                PaymentListView(travelCalculation: $travelCalculation, paymentStore: paymentStore)
                    .padding(.bottom, 12)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            
            NavigationLink {
                PaymentManageView(mode: .add, travelCalculation: $travelCalculation)
                    .environmentObject(paymentStore)
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
                        .foregroundStyle(Color.gray600)
                    
                    Spacer()
                }
                .padding(.top, 12)
                .padding(.bottom, 12)
            }
            
            
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray100, lineWidth: 1)
                
            }
            .padding(.leading, 16)
            .padding(.trailing, 16)
        }
    }
    
    var filteringSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button(action: {
                    isShowingSelectCategorySheet = true
                }, label: {
                    if let category = selectedCategory {
                        Text(category.rawValue)
                            .font(.custom("Pretendard-Medium", size: 14))
                            .foregroundStyle(Color.gray600)
                    }
                    else {
                        Text("전체내역")
                            .font(.custom("Pretendard-Medium", size: 14))
                            .foregroundStyle(Color.gray600)
                    }
                    Image("expand_more")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
                .sheet(isPresented: $isShowingSelectCategorySheet) {
                    CategorySelectView(mode: .sheet, selectedCategory: $selectedCategory)
                        .presentationDetents([.fraction(0.3)])
                }
                .onChange(of: selectedCategory, perform: { category in
                    
                    if selectedDate == 0 {
                        if let category = selectedCategory {
                            paymentStore.filterCategory(category: category)
                        }
                        else {
                            paymentStore.fetchAll()
                        }
                    }
                    else {
                        if let category = selectedCategory{
                            paymentStore.filterDateCategory(date: selectedDate, category: category)
                        }
                        else {
                            paymentStore.filterDate(date: selectedDate)
                        }
                    }
                })
                
                Spacer()
                
                Text("편집")
                    .font(.custom("Pretendard-Medium", size: 14))
                    .foregroundStyle(Color.gray600)
            }
            .padding(.leading, 17)
            .padding(.trailing, 20)
            .padding(.bottom, 9)
            
            Divider()
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .padding(.bottom, 16)
        }
    }
    
    
    }
