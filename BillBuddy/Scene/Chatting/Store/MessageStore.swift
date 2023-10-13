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

    func fetchMessage() {
        
    }
    
}
