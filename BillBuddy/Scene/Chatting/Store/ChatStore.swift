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
    private let userId = AuthStore.shared.userUid
    
    // 채팅방 목록 가져오기
    func fetchChatList() {
        db.collection("Chat").whereField("memberIds", arrayContains: userId).getDocuments { (snapshot, error) in
            if let snapshot {
                var newChats: [Chat] = []
                for document in snapshot.documents {
                    do {
                        let item = try document.data(as: Chat.self)
                        newChats.append(item)
                    } catch {
                        print("Failed fetch chatting list: \(error)")
                        return
                    }
                }
                self.chats = newChats
            }
        }
        print(chats)
    }
    
    // 채팅방 생성 - 여행방을 개설할 때 채팅도 같이 생성
    func addChattingRoom(travelTitle: String) {
        
        let chatRoom = Chat(
            travelTitle: travelTitle,
            hostId: userId,
            memberIds: [userId],
            unreadMessageCount: [userId: 0]
        )
        
        do {
            try db.collection("Chat").document(chatRoom.id).setData(from: chatRoom)
        } catch {
            print("Failed create chattingRoom: \(error)")
        }
        
    }
    
}
