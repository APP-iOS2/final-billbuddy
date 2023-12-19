//
//  GoogleSignInStore.swift
//  BillBuddy
//
//  Created by SIKim on 12/9/23.
//

import Foundation
import FirebaseFirestore

class SNSSignInService {
    private let db = Firestore.firestore().collection("User")
    
    static let shared = SNSSignInService()
    
    func checkUserInFirestore(userId: String) async -> Bool {
        do {
            let snapshot = try await db.document(userId).getDocument()
            let _ = try snapshot.data(as: User.self)
            return true
        } catch {
            return false
        }
    }
    
    func signInUser(userId: String, name: String, email: String) {
        let user: User = User(email: email, name: name, bankName: "", bankAccountNum: "", isPremium: false, premiumDueDate: Date(), reciverToken: "")
        
        Task {
            if await !checkUserInFirestore(userId: userId) {
                try await FirestoreService.shared.saveDocument(collection: .user, documentId: userId, data: user)
            }
            AuthStore.shared.userUid = userId
            try await UserService.shared.fetchUser()
            UserDefaults.standard.setValue(userId, forKey: "User")
        }
    }
}
