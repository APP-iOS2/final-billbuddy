//
//  NotificationCell.swift
//  BillBuddy
//
//  Created by hj on 2023/10/20.
//

import SwiftUI

struct NotificationCell: View {
    var notification: UserNotification
    var isRead: Bool
    let deleteAction: () -> Void
    let callBack: () -> Void
    
    var body: some View {
        Button {
            callBack()
        } label: {
            HStack(spacing: 12) {
                getImage(for: notification.type, isRead: notification.isChecked)
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(getTitle(for: notification.type))
                        .font(.caption02)
                        .foregroundColor(notification.isChecked ? Color(hex: "AFB0B7") : Color.gray)
                    
                    Text(setContentTitle(noti: notification))
                        .font(.caption01)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(notification.isChecked ? Color(hex: "A8A9AC") : Color.black)
                }
                
                Spacer()
                
                Text(getRelativeTime(notification.addDate))
                    .font(.caption01)
                    .foregroundColor(notification.isChecked ? Color(hex: "AFB0B7") : Color.gray)
                    .padding(.top, -20)
            }
            .frame(height: 80)
            .padding(.horizontal, 16)

        }
        .contextMenu {
                Button(action: {
                    deleteAction()
                }) {
                    Text("삭제")
                        .foregroundColor(.red)
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
    }
    
    private func setContentTitle(noti: UserNotification) -> String {
        if noti.duplicationIds == nil {
            return "\(notification.content)가 있습니다"
        } else {
            return "\(notification.content)\n\(noti.duplicationIds?.count ?? 1)개가 있습니다"
        }
    }
    
    private func getImage(for type: NotiType, isRead: Bool) -> Image {
        switch type {
        case .chatting:
            return Image(isRead ? "chat-read-badge" : "chat-badge")
        case .travel:
            return Image(isRead ? "notification-read-badge" : "notification-badge")
        case .notice:
            return Image(isRead ? "announcement-read-badge" : "announcement-badge")
        case .invite:
            return Image(isRead ? "notification-read-badge" : "notification-badge")
        }
    }

    private func getTitle(for type: NotiType) -> String {
        switch type {
        case .chatting:
            return "채팅"
        case .travel:
            return "지출"
        case .notice:
            return "공지사항"
        case .invite:
            return "초대"
        }
    }
    
    private func getRelativeTime(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let dayDifference = components.day, dayDifference > 0 {
            return "\(dayDifference) 일 전"
        } else if let hourDifference = components.hour, hourDifference > 0 {
            return "\(hourDifference) 시간 전"
        } else if let minuteDifference = components.minute, minuteDifference > 0 {
            return "\(minuteDifference) 분 전"
        } else {
            return "방금"
        }
    }
}

//#Preview {
//    let notification = UserNotification(id: "1", type: .chatting, content: "읽지 않은 메세지를 확인해보세요", contentId: "contentId", addDate: Date(), isChecked: false)
//    return NotificationCell(notification: notification, callBack: { })
//}
