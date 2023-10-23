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
    @EnvironmentObject private var nativeAdViewModel: NativeAdViewModel
    @EnvironmentObject private var userService: UserService
    @ObservedObject var floatingButtonMenuStore: FloatingButtonMenuStore
    
    @State private var selectedFilter: TravelFilter = .paymentInProgress
    @State private var isShowingEditTravelView = false
    @Namespace var animation
    
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                HStack {
                    travelFilterButton
                    Spacer()
                }
                .padding(.leading, 16)
               
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        if let isPremium = userService.currentUser?.isPremium {
                            if !isPremium {
                                NativeAdView(nativeViewModel: nativeAdViewModel)
                                    .frame(height: 94)
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(12)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 16)
                            }
                        }
                        if !userTravelStore.isFetching {
                            ForEach(createTravelList()) { travel in
                                NavigationLink {
                                    // FIXME: 무한루프 -> 안에 들어가서 생성
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
                                        .padding(.leading, 26)
                                        
                                        Spacer()
                                        
                                        Button {
                                            isShowingEditTravelView.toggle()
                                        } label: {
                                            Image(.steps13)
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                        }
                                        .padding(.trailing, 23)
                                        .sheet(isPresented: $isShowingEditTravelView) {
                                            EditTravelSheetView()
                                                .presentationDetents([.height(250)])
                                        }
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 94)
                                    .background(Color.gray1000.cornerRadius(12))
                                }
                                .padding(.top, 16)
                                
                            } //MARK: LIST
                            .padding(.horizontal, 16)
                        } else {
                            progressView
                        } //MARK: else
                    }
                    
                } //MARK: SCROLLVIEW
                //                }
                Divider().padding(0)
            } //MARK: VSTACK
            
        } //MARK: ZSTACK
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(.mainBillBuddy)
                    .resizable()
                    .frame(width: 116, height: 23)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    NotificationListView()
                } label: {
                    Image(.ringingBellNotification3)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
        .overlay(
            Rectangle()
                .fill(Color.systemBlack.opacity(isShowingEditTravelView ? 0.6 : 0)).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isShowingEditTravelView = false
                }
        )
        .overlay(
            Rectangle()
                .fill(Color.systemBlack.opacity(floatingButtonMenuStore.isDimmedBackground ? 0.6 : 0)).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    floatingButtonMenuStore.isDimmedBackground = false
                    floatingButtonMenuStore.closeMenu()
                }
        )
        .overlay(
            AddTravelButtonView(floatingButtonMenuStore: floatingButtonMenuStore)
                .onTapGesture {
                    floatingButtonMenuStore.isDimmedBackground = true
                }
        )
        
        .toolbar(tabBarVisivilyStore.visivility, for: .tabBar)
        
        .onAppear {
            tabBarVisivilyStore.showTabBar()
            if let isPremium = userService.currentUser?.isPremium {
                if !isPremium {
                    nativeAdViewModel.refreshAd()
                }
            }
            if !AuthStore.shared.userUid.isEmpty {
                userTravelStore.fetchTravelCalculation()
                if notificationStore.didFetched == false {
                    notificationStore.getUserUid()
                }
            }
            
        }
        .onDisappear {
            floatingButtonMenuStore.isDimmedBackground = false
            floatingButtonMenuStore.closeMenu()
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
    
    var progressView: some View {
        VStack(spacing: 0) {
            ForEach(0..<userTravelStore.travelCount) { _ in
                HStack {
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 60, height: 24)
                            .foregroundColor(.gray200)
                            .padding(.bottom, 4)
                        
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 108, height: 20)
                            .foregroundColor(.gray200)
                    }
                    .padding(.leading, 26)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 94)
                .background(Color.gray050.cornerRadius(12))
            }
            .padding(.top, 16)
            
            HStack {
                Spacer()
                ProgressView()
                    .frame(width: 30, height: 30)
                Spacer()
            }
            .padding(.top, 19)
            
        }
        .padding(.horizontal, 16)
    }
}
#Preview {
    NavigationStack {
        TravelListView(floatingButtonMenuStore: FloatingButtonMenuStore())
            .environmentObject(UserTravelStore())
            .environmentObject(TabBarVisivilyStore())
            .environmentObject(NotificationStore())
            .environmentObject(UserService.shared)
            .environmentObject(NativeAdViewModel())
    }
}


