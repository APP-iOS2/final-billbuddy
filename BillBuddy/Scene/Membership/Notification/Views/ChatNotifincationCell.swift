//
//  ChatNotifincationCell.swift
//  BillBuddy
//
//  Created by hj on 2023/10/10.
//

import SwiftUI

struct ChatNotifincationCell: View {
    @Binding var isRead: Bool
    
    var userNameId: String = "여행돈독방-채팅"
    var chatContent: String = "읽지 않은 메세지를 확인해보세요."
    var timeAgo: String = "1 시간 전"
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                if isRead {
                    Image(.chatReadBadge)
                        .frame(width: 40, height: 40)
                } else {
                    Image(.chatBadge)
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
                Text(userNameId)
                    .font(.caption02)
                    .foregroundColor(isRead ? Color(hex: "AFB0B7") : Color.gray600)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(chatContent)
                    .font(.body04)
                    .foregroundColor(isRead ? Color(hex: "A8A9AC") : Color.systemBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            Text(timeAgo)
                .font(.caption02)
                .foregroundColor(isRead ? Color(hex: "AFB0B7") : Color.gray600)
                .multilineTextAlignment(.trailing)
        }
    }
}

///#Preview {
///    ChatNotifincationCell()
///}
