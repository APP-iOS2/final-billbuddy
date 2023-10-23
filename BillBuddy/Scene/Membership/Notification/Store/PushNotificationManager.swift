//
//  PushNotificationManager.swift
//  BillBuddy
//
//  Created by hj on 2023/10/21.
//

import Foundation

class PushNotificationManager {
    static func sendPushNotification(title: String, body: String) {
        let receiverFCM = "fVrQ-YApOkEAnXsjqoJPrb:APA91bF9kM2ioml9o0XCzDM7THy2L1zaqk28ySlQnGz7yqQSsfqZX4jnOkW2Jc1ASHSjnqKy0zsWnDmjPFGj3mGFXD_0-fVQliFWFoe9Yw5sfwA3S1p2q15QgtY_-4l9OZrHM9fNZcax"
        let serverKey = "AAAAArtiVKU:APA91bHe859jtxmBznArhr7CQtgCfrj-ozXQeqZkXXKEMBwUt29jNUDDllZMDIIyGvp9FTpLd04R72FQEThYuqsiQmRnzxTiBxBl0Auh2naxwd6IvG-grCxwADigJtlBn5nzICo_uh2K"
        
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "to": receiverFCM,
            "notification": [
                "title": title,
                "body": body
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
