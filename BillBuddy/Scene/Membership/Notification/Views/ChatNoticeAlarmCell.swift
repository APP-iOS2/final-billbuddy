//
//  ChatNoticeAlarmCell.swift
//  BillBuddy
//
//  Created by hj on 2023/10/19.
//

import SwiftUI

struct ChatNoticeAlarmCell: View {
    @Binding var isRead: Bool
    
    var noticeTitle: String = "여행돈독방-공지"
    var noticeContent: String = "공지사항이 추가되었습니다."
    var noticeTimeAgo: String = "1 시간 전"
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                if isRead {
                    Image(.announcementReadBadge)
                        .frame(width: 40, height: 40)
                } else {
                    Image(.announcementBadge)
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
                Text(noticeTitle)
                    .font(.caption02)
                    .foregroundColor(isRead ? Color(hex: "AFB0B7") : Color.gray600)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(noticeContent)
                    .font(.body04)
                    .foregroundColor(isRead ? Color(hex: "A8A9AC") : Color.systemBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            Text(noticeTimeAgo)
                .font(.caption02)
                .foregroundColor(isRead ? Color(hex: "AFB0B7") : Color.gray600)
                .multilineTextAlignment(.trailing)
        }
    }
}

///#Preview {
///    ChatNoticeAlarmCell()
///}
