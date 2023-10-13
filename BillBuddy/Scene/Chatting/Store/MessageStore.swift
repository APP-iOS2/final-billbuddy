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
            .collection("Message").order(by:"sendDate").getDocuments() { snapshot, error in
                if let snapshot {
                    var newMessage: [Message] = []
                    for document in snapshot.documents {
                        do {
                            let item = try document.data(as: Message.self)
                            newMessage.append(item)
                        } catch {
                            print("Failed fetch chatting message: \(error)")
                            return
                        }
                    }
                    self.messages = newMessage
                }
            }
    }
    
}
