//
//  CategoryLabel.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/9/23.
//

import SwiftUI

struct CategoryLabel: View {
    var category: Payment.PaymentType
    var payment: Int
    
    var body: some View {
        HStack {
            Image("\(category.imageString)-thin")
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.systemGray08)
            Text(category.typeString)
                .font(.body04)
                .foregroundStyle(Color.systemGray08)
            Spacer()
            Text(payment.wonAndDecimal)
                .font(.body02)
                .foregroundStyle(Color.systemBlack)
        }
    }
}

#Preview {
    CategoryLabel(category: .accommodation, payment: 3000)
}
