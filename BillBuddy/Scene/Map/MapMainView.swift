//
//  MapMainView.swift
//  BillBuddy
//
//  Created by 이승준 on 10/12/23.
//

import SwiftUI

struct MapMainView: View {
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var paymentStore: PaymentStore
    
    @Binding var travelCalculation: TravelCalculation
    @Binding var selectedDate: Double
    
    var body: some View {
        ScrollView {
            MapSubView(locationManager: locationManager, paymentStore: paymentStore)
                .frame(height: 400)
            Button(action: {
                locationManager.setAnnotations(filteredPayments: paymentStore.filteredPayments)
            }, label: {
                Text("어노테이션 테스트") 
            })
            MapDetailView(paymentStore: paymentStore)
            Spacer()
        }
    }
}

//#Preview {
//    MapMainView(paymentStore: PaymentStore(), travelCalculation: .constant(<#T##value: TravelCalculation##TravelCalculation#>))
//}
