//
//  GoogleSignInStore.swift
//  BillBuddy
//
//  Created by SIKim on 12/9/23.
//

import Foundation
import FirebaseFirestore

class SNSSignInService {
    @Published var tempUser: User?
    var tempUid: String = ""
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
    
    func signInUser(userId: String, name: String, email: String, phoneNum: String) {
        let user: User = User(email: email, name: name, phoneNum: phoneNum, bankName: "", bankAccountNum: "", isPremium: false, premiumDueDate: Date(), reciverToken: "")
        Task {
            if await !checkUserInFirestore(userId: userId) {
                tempUser = user
            }
            tempUid = userId
            
            if tempUser == nil {
                AuthStore.shared.userUid = tempUid
                try await UserService.shared.fetchUser()
                UserDefaults.standard.setValue(tempUid, forKey: "User")
                tempUid = ""
                tempUser = nil
            }
        }
    }
    
    func signInUserFirstTime() {
        Task {
            if await !checkUserInFirestore(userId: tempUid) {
                try await FirestoreService.shared.saveDocument(collection: .user, documentId: tempUid, data: tempUser)
            }
            AuthStore.shared.userUid = tempUid
            try await UserService.shared.fetchUser()
            UserDefaults.standard.setValue(tempUid, forKey: "User")
            tempUid = ""
            tempUser = nil
        }
    }
}
