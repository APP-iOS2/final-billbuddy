//
//  DetailMainView.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/26.
//

import SwiftUI


struct DetailMainView: View {
    @ObservedObject var paymentStore: PaymentStore
    
    let days = ["7월 8일 월요일", "7월 9일 화요일", "7월 10일 수요일", "7월 11일 목요일"]
    
    @State private var selectedDaysIdx = 0
    
    var body: some View {
        
        VStack {
            HStack {
                Button(action: {
                    selectedDaysIdx -= 1
                    if selectedDaysIdx < 0 {
                        selectedDaysIdx = 0
                    }
                }, label: {
                    Text("<")
                })
                .disabled(selectedDaysIdx == 0)
                
                Text(days[selectedDaysIdx])
                
                Button(action: {
                    selectedDaysIdx += 1
                    if selectedDaysIdx >= days.count {
                        selectedDaysIdx = days.count - 1
                    }
                }, label: {
                    Text(">")
                })
                .disabled(selectedDaysIdx == days.count - 1)
            }
            .padding()
            
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
                
                PaymentListView(paymentStore: paymentStore)
                
                Section {
                    NavigationLink {
                        AddPaymentView(paymentStore: paymentStore)
                            .navigationTitle("지출 항목 추가")
                        // TODO: custom back button
//                            .navigationBarBackButtonHidden()
//                            .toolbar {
//                                ToolbarItem(placement: .topBarLeading) {
//                                    Button(action: {
//                                        
//                                    }, label: {
//                                        Image(systemName: "chevron.backward")
//                                    })
//                                    
//                                }
//                            }
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .padding()
                                .tint(.gray)
                            VStack(alignment: .leading) {
                                if paymentStore.payments.count != 0 {
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
        }
        
        
        
        
        .onAppear {
            paymentStore.fetchAll()
        }
        
        
    }
}

//#Preview {
//    DetailMainView(paymentStore: PaymentStore(travelCalculationId: ""))
//}
