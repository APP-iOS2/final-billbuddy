//
//  DetailMainView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/9/23.
//

import SwiftUI

struct DetailMainView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var notificationStore: NotificationStore
    @EnvironmentObject private var settlementExpensesStore: SettlementExpensesStore
    @EnvironmentObject private var tabBarVisivilyStore: TabBarVisivilyStore
    @StateObject var paymentStore: PaymentStore
    @StateObject var travelDetailStore: TravelDetailStore
    @StateObject private var locationManager = LocationManager()
    
    @State private var selection: String = "내역"
    @State private var selectedDate: Double = 0
    @State private var isShowingDateSheet: Bool = false
    
    let menus: [String] = ["내역", "지도"]
    
    func fetchPaymentAndSettledAccount(edit: Bool) {
        Task {
            if edit {
                travelDetailStore.saveUpdateDate()
            }
            await paymentStore.fetchAll()
            settlementExpensesStore.setSettlementExpenses(payments: paymentStore.payments, members: travelDetailStore.travel.members)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            sliderSection
            
            Capsule()
                .frame(height: 1)
                .foregroundStyle(Color.gray400)
            
            dateSelectSection
                .frame(height: 52)
            
            if selection == "내역" {
                // TODO: 새로운 변경사항
                if travelDetailStore.isChangedTravel {
                    Button {
                        Task {
                            fetchPaymentAndSettledAccount(edit: false)
                        }
                    } label: {
                        Text("새로운 변경사항!!")
                    }

                }
                PaymentMainView(selectedDate: $selectedDate, paymentStore: paymentStore, travelDetailStore: travelDetailStore)
                    .environmentObject(travelDetailStore)
            }
            else if selection == "지도" {
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
                        fetchPaymentAndSettledAccount(edit: false)
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
                    SchemeService.shared.removeUrl()
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
                    MoreView(travel: travelDetailStore.travel)
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
    
    var sliderSection: some View {
        HStack(spacing: 12, content: {
            ForEach(menus, id: \.self) { menu in
                Button(action: {
                    withAnimation(Animation.default) {
                        selection = menu
                    }
                }, label: {
                    VStack(spacing: 0) {
                        if selection == menu {
                            Text(menu)
                                .frame(width: 160, height: 41)
                                .font(.body01)
                                .foregroundStyle(Color.myPrimary)
                            Capsule()
                                .frame(width: 160, height: 3)
                                .foregroundStyle(Color.myPrimary)
                        }
                        else {
                            Text(menu)
                                .frame(width: 160, height: 41)
                                .font(.body01)
                                .foregroundStyle(Color.gray400)
                        }
                    }
                })
                
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
                        .font(.body01)
                        .foregroundStyle(.black)
                    Image("expand_more")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
                else {
                    Text(selectedDate.toDate().dateWeekYear)
                        .font(.body01)
                        .foregroundStyle(.black)
                    Text("\(selectedDate.howManyDaysFromStartDate(startDate: travelDetailStore.travel.startDate))일차")
                        .font(.body03)
                        .foregroundStyle(Color.gray600)
                    Image("expand_more")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.gray600)
                }
            }
            .padding(.leading, 16)
            .padding(.bottom, 13)
            .padding(.top, 15)
            
            
            Spacer()
        }
        
        .sheet(isPresented: $isShowingDateSheet, content: {
            DateSheet(locationManager: locationManager, paymentStore: paymentStore,isShowingDateSheet: $isShowingDateSheet, selectedDate: $selectedDate, startDate: travelDetailStore.travel.startDate, endDate: travelDetailStore.travel.endDate)
                .presentationDetents([.fraction(0.4)])
        })
        
        
    }
}

//#Preview {
//    let travel = TravelCalculation(hostId: "", travelTitle: "서울 여행", managerId: "", startDate: <#T##Double#>, endDate: <#T##Double#>, updateContentDate: <#T##Double#>, members: <#T##[TravelCalculation.Member]#>)
//    DetailMainView(paymentStore: PaymentStore(travel: <#T##TravelCalculation#>), travelDetailStore: TravelDetailStore(travel: <#T##TravelCalculation#>))
//}
