//
//  MessageStore.swift
//  BillBuddy
//
//  Created by yuri rho on 2023/10/12.
//

import Foundation
import FirebaseFirestore

final class MessageStore: ObservableObject {
    @Published var messages: [Message] = []
    private let db = Firestore.firestore()
    
    func sendMessage(travelCalculation: TravelCalculation, message: Message) {
        do {
            try db.collection("TravelCalculation").document(travelCalculation.id)
                .collection("Message").addDocument(from: message.self)
        } catch {
            print("Failed send message: \(error)")
        }
    }
    
    func fetchMessages(travelCalculation: TravelCalculation) {
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
