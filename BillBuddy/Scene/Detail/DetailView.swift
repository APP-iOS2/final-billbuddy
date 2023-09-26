//
//  DetailView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct tempMapView: View {
    var body: some View {
        Text("지출내역을 추가하시면\n 지도가 나타납니다")
            .background(.gray)
    }
}

struct PaymentListView: View {
    @ObservedObject var paymentStore: PaymentStore
    
    var body: some View {
        VStack {
            ForEach(paymentStore.payments) { payment in
//                Text("\(payment.travelDate)")
            }
            Text("아직 등록한 지출 항목이 없습니다.\n지출 내역을 추가해주세요")
        }
    }
}

struct DetailView: View {
    @ObservedObject var paymentStore: PaymentStore
    
    var days = ["전체", "7/8", "7/9", "7/10", "7/11"]
    
    @State private var selectedDays = "전체"
    @State private var isShowingAddPaymentSheetView: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(.horizontal) {
                    Picker(selection: $selectedDays, label: Text("Date")) {
                        ForEach(days, id:\.self) { day in
                            Text(day)
                        }
                    }
                    .pickerStyle(.segmented)
//                    .frame(width: 500)
                    .padding()
                }
                
                
                Spacer()
                
                tempMapView()
                
                Spacer()
                
                PaymentListView(paymentStore: paymentStore)
                
                Spacer()
                
            }
            
            
            Button {
                isShowingAddPaymentSheetView = true
            } label: {
                Text("지출 내역 추가")
            }
            .foregroundColor(.white)
            .background(.yellow)
            .frame(width: 300, height: 50)
            .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    
            .sheet(isPresented: $isShowingAddPaymentSheetView, content: {
                AddPaymentSheetView(paymentStore: paymentStore, isShowingAddPaymentSheetView: $isShowingAddPaymentSheetView)
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
//    NavigationStack {
//        DetailView()
//    }
//}
