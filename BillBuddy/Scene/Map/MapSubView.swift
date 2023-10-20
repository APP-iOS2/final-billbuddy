//
//  MapSubView.swift
//  BillBuddy
//
//  Created by 이승준 on 10/12/23.
//

import SwiftUI

struct MapSubView: View {
    
    @StateObject var locationManager: LocationManager
    @StateObject var paymentStore: PaymentStore
    
    @Binding var selectedDate: Double
    
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
        .onChange(of: selectedDate, perform: { date in
            if selectedDate == 0 {
                paymentStore.resetFilter()
            }
            else {
                paymentStore.filterDate(date: date)
            }
            locationManager.setAnnotations(filteredPayments: paymentStore.filteredPayments)
        })
        .onAppear {
            if selectedDate == 0 {
                paymentStore.resetFilter()
            }
            else {
                paymentStore.filterDate(date: selectedDate)
            }
            locationManager.setAnnotations(filteredPayments: paymentStore.filteredPayments)
        }
    }
}

#Preview {
    MapSubView(locationManager: LocationManager(), paymentStore: PaymentStore(travel: TravelCalculation.sampletravel), selectedDate: .constant(0.0))
}
