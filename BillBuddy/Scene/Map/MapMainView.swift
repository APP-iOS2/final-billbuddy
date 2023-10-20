//
//  MapMainView.swift
//  BillBuddy
//
//  Created by 이승준 on 10/12/23.
//

import SwiftUI

struct MapMainView: View {
    @StateObject var locationManager: LocationManager
    @ObservedObject var paymentStore: PaymentStore
    @ObservedObject var travelDetailStore: TravelDetailStore
    @Binding var selectedDate: Double
    
    var body: some View {
        ScrollView {
            MapSubView(locationManager: locationManager, paymentStore: paymentStore, selectedDate: $selectedDate)
                .frame(height: 400)
            MapDetailView(paymentStore: paymentStore)
            Spacer()
        }
    }
}

//#Preview {
//    MapMainView(paymentStore: PaymentStore(), travelCalculation: .constant(<#T##value: TravelCalculation##TravelCalculation#>))
//}
