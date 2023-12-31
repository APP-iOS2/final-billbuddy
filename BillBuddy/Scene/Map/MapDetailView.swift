//
//  MapDetailView.swift
//  BillBuddy
//
//  Created by 이승준 on 10/12/23.
//

import SwiftUI

struct MapDetailView: View {
    @ObservedObject var paymentStore: PaymentStore
    
    var body: some View {
        VStack {
            ForEach(Array(zip(0..<paymentStore.payments.count, paymentStore.filteredPayments)), id: \.0) { index, payment in
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.primary2)
                            .frame(height: 20)
                        Text("\(index + 1)")
                            .font(.body03)
                            .foregroundStyle(Color.white)
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text(payment.content)
                                .font(.body01)
                            Label(payment.address.address, systemImage: "mappin.circle")
                                .font(.body04)
                                .foregroundStyle(Color(hex: "858899"))
                        }
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 70)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "F7F7FA"))
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    MapDetailView(paymentStore: PaymentStore(travel: TravelCalculation.sampletravel))
}
