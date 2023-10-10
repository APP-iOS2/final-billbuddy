//
//  PaymentMainView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/10/23.
//

import SwiftUI

struct PaymentMainView: View {
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var paymentStore: PaymentStore
    @ObservedObject var memberStore: MemberStore
    
    var userTravel: UserTravel
    
    @State var isShowingDateSheet: Bool = false
    
    var body: some View {
        VStack{
            HStack {
                Text("2023년 9월 21일")
                    .bold()
                Button {
                    isShowingDateSheet = true
                } label: {
                    Text("1일차")
                    Image("expand_more")
                        .resizable()
                        .frame(width: 24, height: 24)
                }

                Spacer()
            }
            .padding()
            .sheet(isPresented: $isShowingDateSheet, content: {
                DateSheet(userTravel: userTravel)
                    .presentationDetents([.fraction(0.4)])
            })
            
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
                
                
                Divider()
                
                VStack(alignment: .leading) {
                    HStack {
                        Image("money-cash-bill-1-6")
                            .resizable()
                            .frame(width: 18, height: 18)
                        Text("0")
                        
                        Image("credit-card-5-24")
                            .resizable()
                            .frame(width: 18, height: 18)
                        Text("0")
                        
                        Spacer()
                    }
                }
                
            }
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
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
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
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    NotificationListView()
                } label: {
                    Image("ringing-bell-notification-3")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    MoreView()
                        .navigationTitle("더보기")
                } label: {
                    Image("steps-1 3")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            
        })
        .onAppear {
            paymentStore.fetchAll()
        }
    }
}
