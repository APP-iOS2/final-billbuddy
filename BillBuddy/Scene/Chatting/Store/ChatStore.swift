//
//  ChatStore.swift
//  BillBuddy
//
//  Created by yuri rho on 2023/10/11.
//

import Foundation
import FirebaseFirestore

final class ChatStore: ObservableObject {
    
    @Published var chats: [Chat] = []
    private let db = Firestore.firestore()
    
    // 채팅방 목록 가져오기
    func fetchAll() {
        
    }
    
    // 채팅방 생성 - 여행방을 개설할 때 채팅도 같이 생성
    func addChattingRoom(travelTitle: String) {
        
        let userId = AuthStore.shared.userUid
        let mambers: [Member] = []
        
        let chatRoom = Chat(
            travelTitle: travelTitle,
            hostId: userId,
            member: mambers
        )
        
        do {
            try db.collection("Chat").document(chatRoom.id).setData(from: chatRoom)
        } catch {
            print("Failed create chattingRoom: \(error)")
        }
        
    }
    
}
