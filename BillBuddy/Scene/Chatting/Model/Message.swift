//
//  Message.swift
//  BillBuddy
//
//  Created by yuri rho on 2023/10/11.
//

import Foundation
import FirebaseFirestoreSwift

// MARK: 채팅 메세지 버블 모델
struct Message: Identifiable, Codable {
    
    @DocumentID var id: String?
    // 채팅 메세지 작성자 ID
    let senderId: String
    // 채팅 작성자 이름
    var userName: String?
    // 채팅 작성자 이미지
    var userImage: String?
    // 채팅 메세지 내용
    var message: String?
    // 채팅 이미지 업로드
    var imageString: String?
    // 채팅 메세지 보낸 날짜 시간
    let sendDate: Double
    // 채팅 메세지 확인 여부
    var isRead: Bool
}
