//
//  DetailMainView.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/26.
//

import SwiftUI


struct DetailMainView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var paymentStore: PaymentStore
    @ObservedObject var memberStore: MemberStore
    
    var travelCalculation: TravelCalculation
    
    var body: some View {
        
        VStack {
            List{
                Section{                                 
                    VStack(alignment: .leading, content: {
                        HStack{
                            NavigationLink {
                                SpendingListView()
                            } label: {
                                Text("오늘의 총 지출")
                                Spacer()
                                Text("자세히 보기")
                            }
                        }
                        Text("0원")
                            .bold()
                    })
                    .padding()
                }
                
                PaymentListView(paymentStore: paymentStore, memberStore: memberStore, travelCalculation: travelCalculation)
                
                Section {
                    NavigationLink {
                        AddPaymentView(paymentStore: paymentStore, memberStore: memberStore, travelCalculation: travelCalculation)
                            .navigationTitle("지출 항목 추가")
                            .navigationBarBackButtonHidden()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .padding()
                                .tint(.gray)
                            VStack(alignment: .leading) {
                                if paymentStore.payments.count == 0 {
                                    Text("아직 등록한 지출 항목이 없습니다.\n지출 내역을 추가해주세요.")
                                }
                                else{
                                    Text("지출 내역 추가")
                                }
                            }
                        }
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        NotificationListView()
                    } label: {
                        Text("알림")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        MoreView()
                            .navigationTitle("더보기")
                    } label: {
                        Text("더보기")
                    }
                }
                
            })
        }
        
        .onAppear {
            paymentStore.fetchAll()
        }
    }
}
