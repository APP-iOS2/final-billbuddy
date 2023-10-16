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
    @State private var isShowingEditTravelView = false
    @Namespace var animation
    
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center) {
                HStack {
                    travelFilterButton
                    Spacer()
                }
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(createTravelList()) { travel in
                            NavigationLink {
                                DetailMainView(paymentStore: PaymentStore(travelCalculationId: travel.id), travelCalculation: travel)
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
                                        Image("steps-1 3")
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
                        }
                    }
                
//                .padding(.leading, 15)
                
                AddTravelButtonView(userTravelStore: userTravelStore)
            }
        }
        .navigationTitle("BillBuddy")
        .onAppear {
            userTravelStore.fetchTravelCalculation()
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

#Preview {
    NavigationStack {
        TravelListView()
            .environmentObject(UserTravelStore())
    }
}

