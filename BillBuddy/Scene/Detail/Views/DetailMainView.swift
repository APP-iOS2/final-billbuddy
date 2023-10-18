//
//  DetailMainView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/9/23.
//

import SwiftUI

struct DetailMainView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var tabBarVisivility: Visibility
    @StateObject var paymentStore: PaymentStore
//    @StateObject var travelDetailStore: TravelDetailStore
    @StateObject private var locationManager = LocationManager()
    
    @State var travelCalculation: TravelCalculation
    @State private var selection: Int = 0
    @State private var selectedDate: Double = 0
    @State var isShowingDateSheet: Bool = false
    
    var body: some View {
        VStack {
            SliderView(items: ["내역", "지도"], selection: $selection, defaultXSpace: 12)
            
            dateSelectSection
                .frame(height: 52)
            
            if selection == 0 {
                PaymentMainView(travelCalculation: $travelCalculation, selectedDate: $selectedDate, paymentStore: paymentStore)
            }
            else if selection == 1 {
                MapMainView(locationManager: locationManager, paymentStore: paymentStore, travelCalculation: $travelCalculation, selectedDate: $selectedDate)
            }
        }
        .onChange(of: selectedDate, perform: { date in
            if selectedDate == 0 {
                paymentStore.resetFilter()
            }
            else {
                paymentStore.filterDate(date: date)
            }
        })
        .onAppear {
            tabBarVisivility = .hidden
            if selectedDate == 0 {
                paymentStore.fetchAll()
            }
            else {
                paymentStore.filterDate(date: selectedDate)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(.arrowBack)
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
                    MoreView(travelCalculation: travelCalculation)
                } label: {
                    Image("steps-1 3")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            
        })
        
    }
        
    
    var dateSelectSection: some View {
        
        HStack {
            Button {
                isShowingDateSheet = true
            } label: {
                
                if selectedDate == 0 {
                    Text("전체")
//                        .font(Font.)
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
                        .foregroundStyle(Color.gray600)
                    Image("expand_more")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.leading, 16)
            .padding(.bottom, 13)
            .padding(.top, 15)
            
            
            Spacer()
        }
        
        .sheet(isPresented: $isShowingDateSheet, content: {
            DateSheet(selectedDate: $selectedDate, startDate: travelCalculation.startDate, endDate: travelCalculation.endDate)
                .presentationDetents([.fraction(0.4)])
        })
        
        
    }
}
