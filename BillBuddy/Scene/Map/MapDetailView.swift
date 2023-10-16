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
        ForEach(Array(zip(0..<paymentStore.payments.count, paymentStore.payments)), id: \.0) { index, payment in
            
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(height: 25)
                    Text("\(index + 1)")
                        .font(.custom("Pretendard-Semibold", size: 16))
                        .foregroundStyle(Color.white)
                }
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(payment.content)
                        .font(.custom("Pretendard-Semibold", size: 16))
                    HStack {
                        Image(systemName: "mappin.circle")
                        Text(payment.address.address)
                    }
                    .font(.custom("Pretendard-Medium", size: 14))
                    .foregroundStyle(Color(hex: "858899"))
                }
                .frame(width: 300, height: 80)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "F7F7FA"))
                }
            }
            .padding()
        }
        
    }
}

#Preview {
    MapDetailView(paymentStore: PaymentStore(travelCalculationId: ""))
}
