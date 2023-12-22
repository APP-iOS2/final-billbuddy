//
//  PushNotificationManager.swift
//  BillBuddy
//
//  Created by hj on 2023/10/21.
//

import Foundation
import FirebaseFirestore

class PushNotificationManager {
    static func sendPushNotification(toTravel travel: TravelCalculation, title: String, body: String, senderToken: String) {
        if let serverKey = ServerKeyManager.loadServerKey() {
            let db = Firestore.firestore()
            let roomRef = db.collection("TravelCalculation").document(travel.id)
            
            let members = travel.members.filter { member in
                return member.userId != nil && !member.reciverToken.isEmpty && member.userId != AuthStore.shared.userUid
            }
            
            for member in members {
                let receiverToken = member.reciverToken
                
                sendPushNotificationToToken(receiverToken, title: title, body: body, senderToken: senderToken, serverKey: serverKey)
            }
            print("member \(members)")
        } else {
            print("Failed to load server key.")
        }
    }
    
    static func sendPushNotificationToToken(_ token: String, title: String, body: String, senderToken: String, serverKey: String) {
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "to": token,
            "notification": [
                "title": title,
                "body": body
            ],
            "data": [
                "senderToken": senderToken
            ]
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) {
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                }
            }.resume()
        }
    }
}
