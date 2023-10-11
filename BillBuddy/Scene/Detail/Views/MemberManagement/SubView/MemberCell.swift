//
//  SubView.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/9/23.
//

import SwiftUI

struct MemberCell: View {
    var member: TravelCalculation.Member
    var body: some View {
        HStack {
            Image("DBPin")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(spacing: 0) {
                Text(member.name)
                    .font(.body04)
                    .frame(height: 20)
                Text(member.advancePayment.wonAndDecimal)
                    .font(.body02)
                    .frame(height: 20)
            }
            .padding(.leading, 12)
            .foregroundColor(Color.systemBlack)

            Spacer()
            
        }
        .frame(height: 40)
        .padding([.top, .bottom], 12)
    }
}

#Preview {
    MemberCell(member: TravelCalculation.Member(name: "name", advancePayment: 100, payment: 100))
}
