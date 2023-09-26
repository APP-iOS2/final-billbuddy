//
//  DetailMainView.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/26.
//

import SwiftUI

struct DetailMainView: View {
    @StateObject var travelCalculationStore: TravelCalculationStore = TravelCalculationStore()

    
    var body: some View {
        List {
            ForEach(travelCalculationStore.travelCalculations) { travelCalculation in
                NavigationLink {
                    if let id = travelCalculation.id {
                        let paymentStore = PaymentStore(travelCalculationId: id)
                        DetailView(paymentStore: paymentStore)
                    }
                } label: {
                    Text(travelCalculation.hostId)
                }
            }
        }
        .onAppear {
            travelCalculationStore.fetchAll()
        }
    }
}

#Preview {
    DetailMainView()
}
