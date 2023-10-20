//
//  MessageStore.swift
//  BillBuddy
//
//  Created by yuri rho on 2023/10/12.
//

import Foundation
import FirebaseFirestore

final class MessageStore: ObservableObject {
    private let db = Firestore.firestore()
    @Published var messages: [Message] = []
    @Published var isAddedNewMessage: Bool = false
    
    /// 채팅 메세지 보내기
    func sendMessage(travelCalculation: TravelCalculation, message: Message) {
        do {
            try db.collection("TravelCalculation").document(travelCalculation.id)
                .collection("Message").addDocument(from: message.self)
        } catch {
            print("Failed send message: \(error)")
        }
    }
    
    /// 실시간 채팅 메세지 불러오기
    func fetchMessages(travelCalculation: TravelCalculation) {
        // firestore message에 해당하는 여행 id 채팅 데이터 시간 순으로 불러오기
        db.collection("TravelCalculation").document(travelCalculation.id)
            .collection("Message").order(by: "sendDate")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Failed fetching messages: \(error)")
                    return
                }
                guard let querySnapshot = snapshot else {
                    print("No messages available")
                    return
                }
                // 실시간으로 추가되는 데이터가 있다면 isAddedNewMessage 변수 토글해서 scroll down
                querySnapshot.documentChanges.forEach { change in
                    if change.type == .added {
                        self.isAddedNewMessage.toggle()
                    }
                }
                //저장된 메세지 배열에 추가 - 출력
                var newMessage: [Message] = []
                for document in querySnapshot.documents {
                    do {
                        let item = try document.data(as: Message.self)
                        newMessage.append(item)
                    } catch {
                        print("Failed to fetch chat message: \(error)")
                    }
                }
                self.messages = newMessage
            }
    }
    
}
