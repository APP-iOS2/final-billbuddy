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
    @State private var isShowingAddPaymentSheetView: Bool = false
    
    var body: some View {
        ZStack {
            
            
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
                
                
                PaymentListView(paymentStore: paymentStore)
                
                Spacer()
                
            }
            
            Button(action: {
                isShowingAddPaymentSheetView = true
            }, label: {
                HStack {
                    Spacer()
                    Text("지출 내역 추가")
                        .bold()
                    Spacer()
                }
                .padding()
            })
            .buttonStyle(.borderedProminent)
            .padding()
    
            .sheet(isPresented: $isShowingAddPaymentSheetView, content: {
                AddPaymentSheet(paymentStore: paymentStore, isShowingAddPaymentSheetView: $isShowingAddPaymentSheetView)
                .presentationDetents([.fraction(0.8), .large])
            })
            
            .offset(y: 300) // offset이 가장 아래에 가야 따라간다.
            
        }
        .onAppear {
            paymentStore.fetchAll()
        }
    }
}

//#Preview {
//    DetailMainView(paymentStore: PaymentStore(travelCalculationId: ""))
//}
