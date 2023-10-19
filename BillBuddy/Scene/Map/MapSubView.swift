//
//  MapSubView.swift
//  BillBuddy
//
//  Created by 이승준 on 10/12/23.
//

import SwiftUI

struct MapSubView: View {
    
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var paymentStore: PaymentStore
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    MapViewCoordinater(locationManager: locationManager)
                }
                Button {
                    locationManager.moveFocusOnUserLocation()
                } label: {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 45, height: 45)
                        .shadow(radius: 2, y: 1)
                        .overlay {
                            Image(systemName: "scope")
                                .renderingMode(.template)
                        }
                }
                .offset(CGSize(width: geometry.size.width - 70, height: geometry.size.height - 70))
            }
        }
    }
}

#Preview {
    MapSubView(locationManager: LocationManager(), paymentStore: PaymentStore(travel: TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0.0, endDate: 0.0, updateContentDate: 0.0, members: [])))
}
