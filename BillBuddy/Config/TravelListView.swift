//
//  TravelListView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct TravelListView: View {
    @EnvironmentObject var userTravelStore: UserTravelStore
    @Binding var tabBarVisivility: Visibility
    @Binding var isDimmedBackground: Bool
    @State private var selectedFilter: TravelFilter = .paymentInProgress
    @State private var isShowingEditTravelView = false
    @State private var isAddingTravel = false
//    @State private var isDimmedBackground = false
    @Namespace var animation
    
    
    var body: some View {
        
        NavigationStack{
            ZStack {
                VStack(alignment: .center) {
                    HStack {
                        travelFilterButton
                        Spacer()
                    }
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(createTravelList()) { travel in
                            NavigationLink {
                                DetailMainView(tabBarVisivility: $tabBarVisivility, paymentStore: PaymentStore(travelCalculationId: travel.id), travelCalculation: travel)
                                    .toolbar(tabBarVisivility, for: .tabBar)
                                
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
                    
                    .overlay(
                        AddTravelButtonView(userTravelStore: userTravelStore, isDimmedBackground: $isDimmedBackground)
                            .onTapGesture {
                                isDimmedBackground = false
                                print(isDimmedBackground)
                            }
                    )
                } //MARK: VSTACK
            } //MARK: ZSTACK
        }
        
        .navigationTitle("BillBuddy")
        .onAppear {
            tabBarVisivility = .visible
            if !AuthStore.shared.userUid.isEmpty {
                userTravelStore.fetchTravelCalculation()
            }
        }
        
        
        //        .background(
        //            Color.systemBlack.opacity(isDimmedBackground ? 0.5 : 0)
        //                .edgesIgnoringSafeArea(.all)
        //            )
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
    //
    //    func dimmedBackground() {
    //        isDimmedBackground.toggle()
    //        print(isDimmedBackground)
    //    }
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
//#Preview {
//    NavigationStack {
//        TravelListView(tabBarVisivility: .constant(.visible))
//            .environmentObject(UserTravelStore())
//    }
//}

