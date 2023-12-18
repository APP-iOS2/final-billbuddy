//
//  SettledAccountView2.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/8/23.
//

import SwiftUI

struct SettledAccountView: View {
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var settlementExpensesStore: SettlementExpensesStore
    @EnvironmentObject private var travelDetailStore: TravelDetailStore
    @EnvironmentObject private var userTravelStore: UserTravelStore
    
    @State private var isPresentedAlert: Bool = false
    
    func settleAction(isSettle: Bool) {
        travelDetailStore.setIsPaymentSettled(isSettle: isSettle)
        dismiss()
        userTravelStore.fetchTravelCalculation()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("총지출")
                                .font(.body04)
                                .foregroundStyle(Color.gray600)
                                .padding(.bottom, 2)
                            Text(settlementExpensesStore.settlementExpenses.totalExpenditure.wonAndDecimal)
                                .font(.title05)
                                .foregroundStyle(Color.systemBlack)
                        }
                        Spacer()
                    }
                }
                .padding([.top, .bottom], 12)

                Divider()
                
                Section {
                    VStack(alignment: .leading, spacing: 20) {
                        CategoryLabel(category: .accommodation, payment: settlementExpensesStore.settlementExpenses.totalAccommodation)

                        CategoryLabel(category: .transportation, payment: settlementExpensesStore.settlementExpenses.totalTransportation)
                       
                        CategoryLabel(category: .food, payment: settlementExpensesStore.settlementExpenses.totalFood)
                        
                        CategoryLabel(category: .tourism, payment: settlementExpensesStore.settlementExpenses.totalTourism)
                        
                        CategoryLabel(category: .etc, payment: settlementExpensesStore.settlementExpenses.totalEtc)
                        
                    }
                }
                .padding([.top, .bottom], 20)

                Section {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text("개인별 지출")
                                .font(.body04)
                                .foregroundStyle(Color.gray600)
                            Spacer()
                        }
                        Divider()
                            .padding([.top], 12)
                        VStack(spacing: 0) {
                            ForEach(settlementExpensesStore.settlementExpenses.members, id: \.self.memberData.id) { member in
                                MemeberAcountCell(member: member)
                            }
                        }
                    }
                }
                .padding([.top, .bottom], 16)
            }
            .ignoresSafeArea(.all, edges: .all)
            .overlay(alignment: .bottom) {
                Button {
                    isPresentedAlert = true
                } label: {
                    Text(travelDetailStore.travel.isPaymentSettled ? "여행재개" : "정산하기")
                        .font(Font.body02)
                }
                .frame(width: 332, height: 52)
                .background(Color.myPrimary)
                .cornerRadius(12)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            }
        }
        .alert(isPresented: $isPresentedAlert) {
            Alert(title: Text("정산"),
                  message: Text(travelDetailStore.travel.isPaymentSettled ? "다시 여행을 시작하시겠습니까?" : "최종 정산이 완료되었습니까?"),
                  primaryButton: .destructive(Text("취소"), action: { }),
                  secondaryButton: .default(Text(travelDetailStore.travel.isPaymentSettled ? "재개" : "정산"), action: {
                settleAction(isSettle: !travelDetailStore.travel.isPaymentSettled)
            }))
        }
        .padding([.leading, .trailing], 21)
        .padding([.top, .bottom], 12)
        .formStyle(.automatic)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image("arrow_back")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
            ToolbarItem(placement: .principal) {
                Text("결산")
                    .font(.title05)
                    .foregroundColor(Color.systemBlack)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettledAccountView()
            .environmentObject(SettlementExpensesStore())
            .environmentObject(TravelDetailStore(travel: TravelCalculation.sampletravel))
            .environmentObject(UserTravelStore())
    }
    
}
