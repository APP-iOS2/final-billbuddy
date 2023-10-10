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
    @State private var newTravelData = TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: Date().timeIntervalSince1970, endDate: Date().timeIntervalSince1970, updateContentDate: Date(), members: [])
    @Namespace var animation
    
    
    var body: some View {
        NavigationStack{
            VStack {
                travelFilterButton
                    .padding(.top)
                List {
                    ForEach(createTravelList(), id: \.id) { travelList in
                        NavigationLink {
                            if let id = travelList.id {
                                // travelList.id -> travelCalculation 찾기
//                                let travelCalculation
                                let paymentStore = PaymentStore(travelCalculationId: id)
                                let memberStore = MemberStore(travelCalculationId: id)
                                
                                DetailMainView(paymentStore: paymentStore, memberStore: memberStore, userTravel: travelList)
                                    .navigationTitle(travelList.travelName)
                                    .navigationBarBackButtonHidden()
                            }
                        } label: {
                            Text(travelList.travelName)
                        }
//                        NavigationLink {
//                            
//                        } label: {
//                            Text(travelList.travelName)
//                        }

                        
//                        Text("\(travelList.startDate) - \(travelList.endDate)")
                    }
                }
                NavigationLink(destination: AddTravelView(travelData: $newTravelData)) {
                    AddTravelButtonView()
                }
            }
        }
        .navigationTitle("BillBuddy")
        .onAppear {
            userTravelStore.fetchUserTravel()
        }
    }
    
    func createTravelList() -> [UserTravel] {
        switch selectedFilter {
        case .paymentInProgress:
            return userTravelStore.userTravels.filter { userTravel in
                return !userTravel.isPaymentSettled
            }
        case .paymentSettled:
            return userTravelStore.userTravels.filter { userTravel in
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
                        userTravelStore.fetchUserTravel()
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
