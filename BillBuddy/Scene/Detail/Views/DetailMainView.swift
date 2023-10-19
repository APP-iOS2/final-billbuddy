//
//  DetailMainView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/9/23.
//

import SwiftUI

struct DetailMainView: View {
    
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var settlementExpensesStore: SettlementExpensesStore
    @EnvironmentObject private var tabBarVisivilyStore: TabBarVisivilyStore
    @StateObject var paymentStore: PaymentStore
    @StateObject var travelDetailStore: TravelDetailStore
    @StateObject private var locationManager = LocationManager()
    
    @State private var selection: Int = 0
    @State private var selectedDate: Double = 0
    @State var isShowingDateSheet: Bool = false
    
    var body: some View {
        VStack {
            SliderView(items: ["내역", "지도"], selection: $selection, defaultXSpace: 12)
            
            dateSelectSection
                .frame(height: 52)
            
            if selection == 0 {
                PaymentMainView(selectedDate: $selectedDate, paymentStore: paymentStore, travelDetailStore: travelDetailStore)
            }
            else if selection == 1 {
                MapMainView(locationManager: locationManager, paymentStore: paymentStore, travelDetailStore: travelDetailStore, selectedDate: $selectedDate)
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
            tabBarVisivilyStore.hideTabBar()
            if selectedDate == 0 {
                travelDetailStore.listenTravelDate()
                Task {
                    if travelDetailStore.isFirstFetch {
                        await paymentStore.fetchAll()
                        settlementExpensesStore.setSettlementExpenses(payments: paymentStore.payments, members: travelDetailStore.travel.members)
                        travelDetailStore.isFirstFetch = false
                    }
                }
            }
            else {
                paymentStore.filterDate(date: selectedDate)
            }
        }
        .onDisappear {
            travelDetailStore.stoplistening()
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(tabBarVisivilyStore.visivility, for: .tabBar)
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
                    MoreView(travelDetailStore: travelDetailStore)
                } label: {
                    Image("steps-1 3")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            ToolbarItem(placement: .principal) {
                Text(travelDetailStore.travel.travelTitle)
                    .font(.title05)
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
                    Text("\(selectedDate.howManyDaysFromStartDate(startDate: travelDetailStore.travel.startDate))일차")
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
            DateSheet(locationManager: locationManager, paymentStore: paymentStore, isShowingDateSheet: $isShowingDateSheet, selectedDate: $selectedDate, startDate: <#T##Double#>, endDate: <#T##Double#>)
                .presentationDetents([.fraction(0.4)])
        })
        
        
    }
}
