//
//  TravelExpenseCell.swift
//  BillBuddy
//
//  Created by hj on 2023/10/19.
//

import SwiftUI

struct TravelExpenseCell: View {
    @Binding var isRead: Bool

    var expenseTitle: String = "여행돈독방-지출"
    var expenseContent: String = "식비 지출이 추가되었습니다."
    var expenseTimeAgo: String = "1 시간 전"
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                if isRead {
                    Image(.notificationReadBadge) /// 아이콘 변경
                        .frame(width: 40, height: 40)
                } else {
                    Image(.notificationBadge) /// 아이콘 변경
                        .frame(width: 40, height: 40)
                }
            }
            chatNotificationLabel
        }
        .frame(height: 80)
        .padding(.horizontal, 16)
    }
    
    private var chatNotificationLabel: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(expenseTitle)
                    .font(.caption02)
                    .foregroundColor(isRead ? Color(hex: "AFB0B7") : Color.gray600)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(expenseContent)
                    .font(.body04)
                    .foregroundColor(isRead ? Color(hex: "A8A9AC") : Color.systemBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            Text(expenseTimeAgo)
                .font(.caption02)
                .foregroundColor(isRead ? Color(hex: "AFB0B7") : Color.gray600)
                .multilineTextAlignment(.trailing)
        }
    }
}

///#Preview {
///    TravelExpenseCell()
///}
