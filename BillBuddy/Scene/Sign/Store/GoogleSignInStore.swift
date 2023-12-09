//
//  GoogleSignInStore.swift
//  BillBuddy
//
//  Created by SIKim on 12/9/23.
//

import Foundation
import FirebaseFirestore

class GoogleSignInStore {
    private let db = Firestore.firestore().collection("User")
    
    func checkUserInFirestore(userId: String, user: User) async -> Bool {
        let name: String = user.name
        let email: String = user.email
        do {
            let snapshot = try await db.document(userId).getDocument()
            let data = try snapshot.data(as: User.self)
            if data.name == name && data.email == email {
                return false
            }
        } catch {
            print(error)
        }
        return true
    }
    
    func signInUser(userId: String, name: String, email: String, phoneNum: String) {
        let user: User = User(email: email, name: name, phoneNum: phoneNum, bankName: "", bankAccountNum: "", isPremium: false, premiumDueDate: Date(), reciverToken: "")
        
        Task {
            if await checkUserInFirestore(userId: userId, user: user) {
                try await FirestoreService.shared.saveDocument(collection: .user, documentId: userId, data: user)
            }
            AuthStore.shared.userUid = userId
            try await UserService.shared.fetchUser()
            UserDefaults.standard.setValue(userId, forKey: "User")
        }
    }
}
