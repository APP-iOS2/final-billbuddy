//
//  PaymentListView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI


struct PaymentListView: View {
    @ObservedObject var paymentStore: PaymentStore
    
    @State private var isShowingEditPaymentSheet = false
    
    var body: some View {
        VStack {
            if paymentStore.payments.count == 0 {
                Text("아직 등록한 지출 항목이 없습니다.\n지출 내역을 추가해주세요")
            }
            else {
            }
            
            List{
                Section{
                    VStack(alignment: .leading, content: {
                        HStack{
                            Text("오늘의 총 지출")
                            Spacer()
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Text("자세히 보기")
                            })
                        }
                        Text("0원")
                            .bold()
                    })
                    .padding()
                }
                
                ForEach(paymentStore.payments) { payment in
                    Button {
                        isShowingEditPaymentSheet = true
                    } label: {
                        HStack{
                            Image(systemName: "square.and.arrow.down.fill")
                            VStack(alignment: .leading, content: {
                                Text("3,000,000")
                                    .bold()
                                Text("파라다이스 호텔")
                            })
                        }
                    }
                    
                    .sheet(isPresented: $isShowingEditPaymentSheet, content: {
                        // TODO: EditPaymentSheet 만들어야한다.
                        AddPaymentSheet(paymentStore: paymentStore, isShowingAddPaymentSheetView: $isShowingEditPaymentSheet)
                            .presentationDetents([.fraction(0.8), .large])
                    })

                    
                }
            }
            
        }
    }
}
