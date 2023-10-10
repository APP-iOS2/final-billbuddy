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
                    Text(selectedDate.toDate().dateWeek)
                    Image("expand_more")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .onAppear {
                    selectedDate = userTravel.startDate
                }
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $isShowingDateSheet, content: {
                DateSheet(selectedDate: $selectedDate, userTravel: userTravel)
                    .presentationDetents([.fraction(0.4)])
            })
            .frame(height: 52)
            
            GroupBox {
                HStack {
                    VStack(alignment: .leading, content: {
                        HStack{
                            Text("총 지출")
                            Image("chevron_right")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        Text("0원")
                    })
                    
                    Spacer()
                    
                    Button(action: {}, label: {
                        Text("정산하기")
                    })
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
        
        .onAppear {
            paymentStore.fetchAll()
        }
    }
}
