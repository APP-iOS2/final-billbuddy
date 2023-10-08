//
//  MemeberAcountCell.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/8/23.
//

import SwiftUI

struct MemeberAcountCell: View {
    var member: SettlementExpenses.MemberPayment
    
    var body: some View {
        HStack {
            Image("DBPin")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack {
                Text(member.memberData.name)
                    .font(.body04)
                Text(member.최종n빵금액.wonAndDecimal)
                    .font(.body02)
            }
            .foregroundStyle(Color.systemBlack)

            Spacer()
            Button {
                // 계좌복사버튼
            } label: {
                HStack {
                    Text("계좌정보")
                    Image("multiple-file-1-5")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 18, height: 18)
                }
            }
            .foregroundColor(.systemGray07)
            .font(.body04)
            
            

            
        }
        .frame(height: 40)
        .padding([.top, .bottom], 12)
    }
}

#Preview {
    MemeberAcountCell(member: SettlementExpenses.MemberPayment())
}
