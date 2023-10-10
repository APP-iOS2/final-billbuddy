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
                            }
                        } label: {
                            Text(travelList.travelName)
                        }
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
                    if filter == selectedFilter {
                        Text(filter.title)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(.vertical, 4)
                            .padding([.leading, .trailing], 10)
                            .background(Color.white)
                            .cornerRadius(20)
                    } else {
                        Text(filter.title)
                            .padding(.vertical, 4)
                            .padding([.leading, .trailing], 10)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 1.5)
                            )
                    }
                }
                .onTapGesture {
                    self.selectedFilter = filter
                    userTravelStore.fetchUserTravel()
                    print(self.selectedFilter)
                }
            }
        }
    }
}

#Preview {
    TravelListView()
}
