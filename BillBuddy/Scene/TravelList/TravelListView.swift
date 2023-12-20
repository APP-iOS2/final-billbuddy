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
    @EnvironmentObject private var tabViewStore: TabViewStore
    @StateObject private var travelDetailStore: TravelDetailStore = TravelDetailStore(travel: .sampletravel)
    @ObservedObject var floatingButtonMenuStore: FloatingButtonMenuStore
    
    @State private var selectedFilter: TravelFilter = .paymentInProgress
    @State private var isShowingEditTravelView = false
    @State private var selectedTravel: TravelCalculation = .sampletravel
    
    @State private var isPresentedDateView: Bool = false
    @State private var isPresentedMemeberView: Bool = false
    @State private var isPresentedSpendingView: Bool = false
//    @Namespace var animation
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    travelFilterButton
                    Spacer()
                }
                .padding(.leading, 20)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
//                        if let isPremium = userService.currentUser?.isPremium {
//                            if !isPremium {
//                                NativeAdView(nativeViewModel: nativeAdViewModel)
//                                    .frame(height: 94)
//                                    .frame(maxWidth: .infinity)
//                                    .cornerRadius(12)
//                                    .padding(.horizontal, 16)
//                                    .padding(.top, 16)
//                            }
//                        }
                        if !userTravelStore.isFetching {
                            //.onAppear 애니메이션 효과 때문에 문장이 접혔다 펴지는 문제가 있음
                            if selectedFilter == .paymentInProgress && createTravelList().isEmpty {
                                    Text("정산 중인 여행이 없습니다.")
                                        .font(.body04)
                                        .foregroundColor(.gray600)
                                        .padding(.top, 270)
                                        .lineLimit(1)
                                        .lineSpacing(25)
                            } else if selectedFilter == .paymentSettled && createTravelList().isEmpty {
                                    Text("정산이 완료된 여행이 없습니다.")
                                        .font(.body04)
                                        .foregroundColor(.gray600)
                                        .padding(.top, 270)
                                        .lineLimit(1)
                                        .lineSpacing(25)
                            } else {
                                ForEach(createTravelList()) { travel in
                                    Button {
                                        tabViewStore.pushView(type: .travel, travel: travel)
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
                                                travelDetailStore.setTravel(travel: travel)
                                                selectedTravel = travel
                                                isShowingEditTravelView.toggle()
                                            } label: {
                                                Image(.steps13)
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                            }
                                            .padding(.trailing, 23)
                                            .sheet(isPresented: $isShowingEditTravelView) {
                                                EditTravelSheetView(
                                                    isPresentedSheet: $isShowingEditTravelView,
                                                    isPresentedDateView: $isPresentedDateView,
                                                    isPresentedMemeberView: $isPresentedMemeberView,
                                                    isPresentedSpendingView: $isPresentedSpendingView,
                                                    travel: selectedTravel
                                                )
                                                .presentationDetents([.height(250)])
                                            }
                                            .navigationDestination(isPresented: $isPresentedDateView) {
                                                DateManagementView(
                                                    travel: travel,
                                                    paymentDates: [],
                                                    entryViewtype: .list
                                                )
                                                .environmentObject(travelDetailStore)
                                            }
                                            .navigationDestination(isPresented: $isPresentedMemeberView) {
                                                MemberManagementView(
                                                    travel: selectedTravel
                                                )
                                                .environmentObject(travelDetailStore)
                                            }
                                            .navigationDestination(isPresented: $isPresentedSpendingView) {
                                                SettledAccountView(entryViewtype: .list)
                                                    .environmentObject(travelDetailStore)

                                            }
                                            
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 94)
                                        .background(Color.gray1000.cornerRadius(12))
                                    }
                                    .padding(.top, 12)
                                    
                                } //MARK: LIST
                                .padding(.horizontal, 12)
                            }
                            
                        } else {
                            progressView
                        } //MARK: else
                        
                        
                    }
                    
                } //MARK: SCROLLVIEW
                //                }
                Divider().padding(0)
            } //MARK: VSTACK
            
        } //MARK: ZSTACK
        .navigationDestination(isPresented: $tabViewStore.isPresentedDetail) {
            DetailMainView(
                paymentStore: PaymentStore(travel: tabViewStore.seletedTravel),
                travelDetailStore: TravelDetailStore(travel: tabViewStore.seletedTravel)
            )
        }
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
            userTravelStore.fetchFirstInit()
            if !AuthStore.shared.userUid.isEmpty {
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
//                            .matchedGeometryEffect(id: "filter", in: animation)
                    } else {
                        Capsule()
                            .foregroundColor(.gray100)
                            .frame(width: 100, height: 3)
                    }
                }
                .onTapGesture {
//                    withAnimation(Animation.default) {
                        self.selectedFilter = filter
                        print(self.selectedFilter)
//                    }
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
//#Preview {
//    NavigationStack {
//        TravelListView(floatingButtonMenuStore: FloatingButtonMenuStore())
//            .environmentObject(UserTravelStore())
//            .environmentObject(TabBarVisivilyStore())
//            .environmentObject(NotificationStore())
//            .environmentObject(UserService.shared)
//            .environmentObject(NativeAdViewModel())
//    }
//}


