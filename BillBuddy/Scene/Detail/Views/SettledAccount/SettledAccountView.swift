//
//  SettledAccountView2.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/8/23.
//

import SwiftUI

struct SettledAccountView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var settlementExpensesStore: SettlementExpensesStore
    
    var body: some View {
        ScrollView {
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("총지출")
                            .font(.body04)
                            .foregroundStyle(Color.systemGray07)
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
                VStack {
                    HStack {
                        Text("개인별 지출")
                            .font(.body04)
                            .foregroundStyle(Color.systemGray07)
                        Spacer()
                    }
                    Divider()
                        .padding([.top], 12)
                    VStack {
                        ForEach(settlementExpensesStore.settlementExpenses.members, id: \.self.memberData.id) { member in
                            MemeberAcountCell(member: member)
                        }
                    }
                }
            }
            .padding([.top, .bottom], 16)
        }
        .padding([.leading, .trailing], 21)
        .padding([.top, .bottom], 12)
        .formStyle(.automatic)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
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
            
            
        })
    }
}

#Preview {
    NavigationStack {
        SettledAccountView(settlementExpensesStore: SettlementExpensesStore())
//            .environmentObject(SettlementExpensesStore())
    }
    
}