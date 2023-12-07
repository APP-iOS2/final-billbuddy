//
//  MapMainView.swift
//  BillBuddy
//
//  Created by 이승준 on 10/12/23.
//

import SwiftUI

struct MapMainView: View {
    @StateObject var locationManager: LocationManager
    @EnvironmentObject private var paymentStore: PaymentStore
    @EnvironmentObject private var travelDetailStore: TravelDetailStore
    @Binding var selectedDate: Double
    
    var body: some View {
        ScrollView {
            MapSubView(locationManager: locationManager, selectedDate: $selectedDate)
                .frame(height: 230)
            MapDetailView()
        }
    }
}

//#Preview {
//    MapMainView(paymentStore: PaymentStore(), travelCalculation: .constant(<#T##value: TravelCalculation##TravelCalculation#>))
//}
