//
//  TravelListView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct TravelListView: View {
    @EnvironmentObject private var userTravelStore: UserTravelStore
    @EnvironmentObject private var tabBarVisivilyStore: TabBarVisivilyStore
    @ObservedObject var floatingButtonMenuStore: FloatingButtonMenuStore
//    @Binding var isDimmedBackground: Bool
    
    @State private var selectedFilter: TravelFilter = .paymentInProgress
    @State private var isShowingEditTravelView = false
    @State private var isAddingTravel = false
    @Namespace var animation
    
    
    var body: some View {
        
        ZStack {
            VStack(alignment: .center) {
                HStack {
                    travelFilterButton
                    Spacer()
                }
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
                                    Text("\(travel.startDate.toFormattedMonthandDay()) - \(travel.endDate.toFormattedMonthandDay())")
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
                            .padding([.leading, .trailing], 26)
                            .frame(width: 361, height: 95)
                            .background(Color.gray1000.cornerRadius(12))
                        }
                        
                    } //MARK: LIST
                    
                } //MARK: SCROLLVIEW
                
                
            } //MARK: VSTACK
            
            
            
//            Color.systemBlack.opacity(isDimmedBackground ? 0.5 : 0).edgesIgnoringSafeArea(.all)
//            .background(Color.systemBlack.opacity(isDimmedBackground ? 0.5 : 0))
//
            
        } //MARK: ZSTACK
//        .background(Color.systemBlack.opacity(isDimmedBackground ? 0.5 : 0)).edgesIgnoringSafeArea(.all)
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
                Text("BillBuddy")
                    .font(.title04)
                    .foregroundColor(.myPrimary)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Image(.ringingBellNotification3)
                    .resizable()
                    .frame(width: 24, height: 24)
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
        
    }
    
    func createTravelList() -> [TravelCalculation] {
        var sortedTravels: [TravelCalculation]
        
        switch selectedFilter {
        case .paymentInProgress:
            return userTravelStore.travels.filter { userTravel in
                return !userTravel.isPaymentSettled
            }
        case .paymentSettled:
            return userTravelStore.travels.filter { userTravel in
                return userTravel.isPaymentSettled
            }
        }
        
        sortedTravels.sort { $0.startDate < $1.startDate}
        
        return sortedTravels
    }
}

extension TravelListView {
    var travelFilterButton: some View {
        HStack {
            ForEach(TravelFilter.allCases, id: \.rawValue) { filter in
                VStack {
                    Text(filter.title)
                        .padding(.top, 30)
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
                            .foregroundColor(.clear)
                            .frame(width: 100, height: 3)
                    }
                }
                .onTapGesture {
                    withAnimation(Animation.default) {
                        self.selectedFilter = filter
                        //                        userTravelStore.fetchTravelCalculation()
                        print(self.selectedFilter)
                    }
                }
            }
        }
    }
}
//
//
//#Preview {
//    NavigationStack {
//        TravelListView(tabBarVisivility: .constant(.visible))
//            .environmentObject(UserTravelStore())
//            .environmentObject(TabBarVisivilyStore())
//    }
//}

    
