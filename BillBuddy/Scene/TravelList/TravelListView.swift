//
//  TravelListView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct TravelListView: View {
    @EnvironmentObject private var userTravelStore: UserTravelStore
    @EnvironmentObject private var notificationStore: NotificationStore
    @EnvironmentObject private var tabBarVisivilyStore: TabBarVisivilyStore
    @ObservedObject var floatingButtonMenuStore: FloatingButtonMenuStore
    
    @State private var selectedFilter: TravelFilter = .paymentInProgress
    @State private var isShowingEditTravelView = false
    @State private var isAddingTravel = false
    @Namespace var animation
    
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .leading) {
                HStack {
                    travelFilterButton
                    Spacer()
                }
                .padding(.leading, 12)
                
                // 리스트간 간격이 너무 넓음
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(createTravelList()) { travel in
                        NavigationLink {
                            DetailMainView(paymentStore: PaymentStore(travel: travel), travelDetailStore: TravelDetailStore(travel: travel))
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(travel.travelTitle)
                                        .font(.body01)
                                        .foregroundColor(.black)
                                        .padding(.bottom, 5)
                                    Text("\(travel.startDate.toFormattedYearandMonthandDay()) - \(travel.endDate.toFormattedYearandMonthandDay())")
                                        .font(.caption02)
                                        .foregroundColor(Color.gray600)
                                }
                                
                                Spacer()
                                
                                Button {
                                    isShowingEditTravelView.toggle()
                                } label: {
                                    Image(.steps13)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                                .sheet(isPresented: $isShowingEditTravelView) {
                                    EditTravelSheetView()
                                        .presentationDetents([.height(250)])
                                }
                                
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 94)
                            .padding([.leading, .trailing], 25)
                            .background(Color.gray1000.cornerRadius(12))
                        }
                        .padding(.top, 16) // 간격 너무 멀어보임
                        
                    } //MARK: LIST
                    .padding([.leading, .trailing], 12)
                    
                } //MARK: SCROLLVIEW
                
            } //MARK: VSTACK
            
        } //MARK: ZSTACK
        .overlay(
        Rectangle()
            .fill(Color.systemBlack.opacity(isShowingEditTravelView ? 0.5 : 0)).edgesIgnoringSafeArea(.all)
            .onTapGesture {
                isShowingEditTravelView = false
            }
        )
        .overlay(
            Rectangle()
                .fill(Color.systemBlack.opacity(floatingButtonMenuStore.isDimmedBackground ? 0.5 : 0)).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    floatingButtonMenuStore.isDimmedBackground = false
                    floatingButtonMenuStore.closeMenu()
                }
        )
        .overlay(
            AddTravelButtonView(userTravelStore: userTravelStore, floatingButtonMenuStore: floatingButtonMenuStore)
                .onTapGesture {
                    floatingButtonMenuStore.isDimmedBackground = true
                }
        )
        
        .toolbar(tabBarVisivilyStore.visivility, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(.mainBillBuddy)
                    .resizable()
                    .frame(width: 116, height: 23)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    //알림 뷰 자리
                } label: {
                    Image(.ringingBellNotification3)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
        .onAppear {
            tabBarVisivilyStore.showTabBar()
            if !AuthStore.shared.userUid.isEmpty {
                userTravelStore.fetchTravelCalculation()
            }
        }
        .onDisappear {
            floatingButtonMenuStore.isDimmedBackground = false
        }
        
    } //MARK: BODY
    
    func createTravelList() -> [TravelCalculation] {
        var sortedTravels: [TravelCalculation]
        
        switch selectedFilter {
        case .paymentInProgress:
            sortedTravels = userTravelStore.travels.filter { userTravel in
                return !userTravel.isPaymentSettled
            }
        case .paymentSettled:
            sortedTravels = userTravelStore.travels.filter { userTravel in
                return userTravel.isPaymentSettled
            }
        }
        
        let sortingTravels = sortedTravels.sorted { travel1, travel2 in
            if travel1.startDate != travel2.startDate {
                return travel1.startDate < travel2.startDate
            } else {
                return travel1.endDate < travel2.endDate
            }
        }
        
        return sortingTravels
    }
}

extension TravelListView {
    var travelFilterButton: some View {
        HStack(spacing: 0) {
            ForEach(TravelFilter.allCases, id: \.rawValue) { filter in
                VStack {
                    Text(filter.title)
                        .padding(.top, 25)
                        .font(Font.body02)
                        .fontWeight(selectedFilter == filter ? .bold : .regular)
                        .foregroundColor(selectedFilter == filter ? .myPrimary : .gray500)
                    
                    if filter == selectedFilter {
                        Capsule()
                            .foregroundColor(Color.myPrimary)
                            .frame(width: 100, height: 3)
                            .matchedGeometryEffect(id: "filter", in: animation)
                    } else {
                        Capsule()
                            .foregroundColor(.gray100)
                            .frame(width: 100, height: 3)
                    }
                }
                .onTapGesture {
                    withAnimation(Animation.default) {
                        self.selectedFilter = filter
                        print(self.selectedFilter)
                    }
                }
            }
        }
    }
}
#Preview {
    NavigationStack {
        TravelListView(floatingButtonMenuStore: FloatingButtonMenuStore())
            .environmentObject(UserTravelStore())
            .environmentObject(TabBarVisivilyStore())
            .environmentObject(NotificationStore())
    }
}


