//
//  Chat.swift
//  BillBuddy
//
//  Created by yuri rho on 2023/10/11.
//

import Foundation
import FirebaseFirestoreSwift

// MARK: 채팅방 모델
struct Chat: Identifiable, Codable {
    
    // 채팅방 ID
    var id: String = UUID().uuidString
    // 채팅방 타이틀
    let travelTitle: String
    // 여행 생성한 멤버 ID
    let hostId: String
//    // 채팅방 생성 날짜
//    let createdDate: Double
    // 채팅에 참여한 유저
    let memberIds: [String]
    // 마지막 메세지 내용 - 미리보기
    var lastMessage: String?
    // 마지막 메세지 날짜 -- 미리보기, 리스트 정렬 순서
    var lastMessageDate: Double?
    // 읽지 않은 메세지 수 [유저아이디 : 갯수]
    var unreadMessageCount: [String : Int]?
        
}
