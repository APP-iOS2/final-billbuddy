//
//  TravelListView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct TravelListView: View {
    @EnvironmentObject var userTravelStore: UserTravelStore
    @State private var selectedFilter: TravelFilter = .paymentInProgress
    @Namespace var animation
    
    
    var body: some View {
        NavigationStack{
            VStack {
                travelFilterButton
                List {
                    ForEach(userTravelStore.travels) { travel in
                        NavigationLink {
                            DetailMainView(travelCalculation: travel)
                        } label: {
                            Text(travel.travelTitle)
                        }
                    }
                }
                
                AddTravelButtonView(userTravelStore: userTravelStore)
            }
        }
        .navigationTitle("BillBuddy")
        .onAppear {
            userTravelStore.fetchTravelCalculation()
        }
    }
    
    func createTravelList() -> [TravelCalculation] {
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
    }
}

extension TravelListView {
    var travelFilterButton: some View {
        HStack {
            ForEach(TravelFilter.allCases, id: \.rawValue) { filter in
                VStack {
                    Text(filter.title)
                        .font(.title3)
                        .fontWeight(selectedFilter == filter ? .bold : .regular)
                        .foregroundColor(selectedFilter == filter ? .primary : .black)
                    
                    if filter == selectedFilter {
                        Capsule()
                            .foregroundColor(.primary)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "filter", in: animation)
                    } else {
                        Capsule()
                            .foregroundColor(.clear)
                            .frame(height: 3)
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

#Preview {
    TravelListView()
}

