//
//  MapMainView.swift
//  BillBuddy
//
//  Created by 이승준 on 10/12/23.
//

import SwiftUI

struct MapMainView: View {
    @StateObject var locationManager = LocationManager()
    @ObservedObject var paymentStore: PaymentStore
    
    @Binding var travelCalculation: TravelCalculation
    
    @State private var isShowingDateSheet: Bool = false
    @State private var selectedDate: Double = 0
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button {
                        isShowingDateSheet = true
                    } label: {
                        if selectedDate == 0 {
                            Text("전체")
                                .font(.custom("Pretendard-Semibold", size: 16))
                                .foregroundStyle(.black)
                            Image("expand_more")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        else {
                            Text(selectedDate.toDate().dateWeekYear)
                                .font(.custom("Pretendard-Semibold", size: 16))
                                .foregroundStyle(.black)
                            Text("\(selectedDate.howManyDaysFromStartDate(startDate: travelCalculation.startDate))일차")
                                .font(.custom("Pretendard-Semibold", size: 14))
                                .foregroundStyle(Color(hex: "858899"))
                            Image("expand_more")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                    Spacer()
                }
                .padding()
                .sheet(isPresented: $isShowingDateSheet, content: {
                    DateSheet(selectedDate: $selectedDate, isShowingDateSheet: $isShowingDateSheet, startDate: travelCalculation.startDate, endDate: travelCalculation.endDate)
                        .presentationDetents([.fraction(0.4)])
                })
                .frame(height: 52)
                .onChange(of: selectedDate, perform: { date in
                    if selectedDate == 0 {
                        paymentStore.fetchAll()
                    }
                    else {
                        paymentStore.fetchDate(date: date)
                    }
                })
                .onAppear {
                    if selectedDate == 0 {
                        paymentStore.fetchAll()
                    }
                    else {
                        paymentStore.fetchDate(date: selectedDate)
                    }
                }
            }
            
            MapSubView(locationManager: locationManager, paymentStore: paymentStore)
                .frame(height: 400)
            Button(action: {
                locationManager.setAnnotations(paymentStore: paymentStore)
            }, label: {
                Text("어노테이션 테스트")
            })
            MapDetailView(paymentStore: paymentStore)
        }
    }
}

//#Preview {
//    MapMainView(paymentStore: PaymentStore(), travelCalculation: .constant(<#T##value: TravelCalculation##TravelCalculation#>))
//}
