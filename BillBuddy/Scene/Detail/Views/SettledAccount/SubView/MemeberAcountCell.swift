//
//  MemeberAcountCell.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/8/23.
//

import SwiftUI
import Kingfisher

struct MemeberAcountCell: View {
    var member: SettlementExpenses.MemberPayment
    
    var body: some View {
        HStack(spacing: 0) {
            if member.memberData.userImage != "" {
                KFImage(URL(string: member.memberData.userImage))
                    .placeholder {
                        ProgressView()
                            .frame(width: 40, height: 40)
                    }
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Image(.defaultUser)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(member.memberData.name)
                    .font(.body04)
                Text(member.lastDividedAmount.wonAndDecimal)
                    .font(.body02)
            }
            .padding(.leading, 12)
            .foregroundStyle(Color.systemBlack)

            Spacer()
            Button {
                UIPasteboard.general.string = "\(member.memberData.bankName) \(member.memberData.bankAccountNum)"
            } label: {
                HStack {
                    Text("계좌정보")
                    Image("multiple-file-1-5")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 18, height: 18)
                }
            }
            .foregroundColor(.gray600)
            .font(.body04)
            
            

            
        }
        .frame(height: 40)
        .padding([.top, .bottom], 12)
    }
}

#Preview {
    MemeberAcountCell(member: SettlementExpenses.MemberPayment())
}
