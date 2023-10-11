//
//  Message.swift
//  BillBuddy
//
//  Created by yuri rho on 2023/10/11.
//

import Foundation
import FirebaseFirestoreSwift

// MARK: 채팅 메세지 버블 모델
struct Message: Identifiable {
    
    @DocumentID var id: String?
    // 채팅 메세지 작성자 ID
    let senderId: String
    // 채팅 메세지 내용
    let message: String
    // 채팅 메세지 보낸 날짜 시간
    let sendDate: Double
    // 채팅 메세지 확인 여부
    var isRead: Bool
}
