//
//  MapMainView.swift
//  BillBuddy
//
//  Created by 이승준 on 10/12/23.
//

import SwiftUI

struct MapMainView: View {
    @StateObject var locationManager = LocationManager()
    @ObservedObject var paymentStore: PaymentStore
    
    @Binding var travelCalculation: TravelCalculation
    
    @Binding var selectedDate: Double
    
    var body: some View {
        ScrollView {
            Text("카테고리셀렉뷰 추가")
            MapSubView(locationManager: locationManager, paymentStore: paymentStore)
                .frame(height: 400)
            Button(action: {
                locationManager.setAnnotations(paymentStore: paymentStore)
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
