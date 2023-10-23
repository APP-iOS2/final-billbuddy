//
//  UserService.swift
//  BillBuddy
//
//  Created by 박지현 on 10/6/23.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import _PhotosUI_SwiftUI

final class UserService: ObservableObject {
    @Published var currentUser: User?
    @Published var isSignIn: Bool = false
    
    var reciverToken: String = ""
    
    static let shared = UserService()
    
    private init() {
        Task {
            try await self.fetchUser()
            try await self.updateUserPremium()
        }
    }
    
    // 현재 유저 패치작업
    @MainActor
    func fetchUser() async throws  {
        let uid: String = AuthStore.shared.userUid
        if uid == "" {
            return
        }
        do {
            let snapshot = try await Firestore.firestore().collection("User").document(uid).getDocument()
            var user: User = try snapshot.data(as: User.self)
            
            if user.reciverToken != self.reciverToken {
                Task {
                    try await updateReciverToken()
                    user.reciverToken = self.reciverToken
                }
            }
            
            currentUser = user
            if currentUser?.premiumDueDate ?? Date() <= Date() {
                currentUser?.isPremium = false
            }
            
            isSignIn = true
        } catch {
            print("Error fetching user: \(error)")
            throw error
        }
    }
    
    @MainActor
    func updateUser() async throws {
        guard let user = currentUser else {
            return
        }
        do {
            let userRef = Firestore.firestore().collection("User").document(AuthStore.shared.userUid)
            let updatedData = [
                "phoneNum": user.phoneNum,
                "email": user.email,
                "bankName": user.bankName,
                "bankAccountNum": user.bankAccountNum
            ]
            try await userRef.setData(updatedData, merge: true)
            print("업데이트 성공")
        } catch {
            print("업데이트 실패: \(error)")
            throw error
        }
    }
    
    @MainActor
    func updateReciverToken() async throws {
        guard let user = currentUser else {
            return
        }
        do {
            let userRef = Firestore.firestore().collection("User").document(AuthStore.shared.userUid)
            let updatedData = [
                "reciverToken": self.reciverToken
            ]
            try await userRef.setData(updatedData, merge: true)
            print("업데이트 성공")
        } catch {
            print("업데이트 실패: \(error)")
            throw error
        }
    }
    
    @MainActor
    func updateUserPremium() async throws {
        guard let user = currentUser else { return }
        do {
            let userRef = Firestore.firestore().collection("User").document(AuthStore.shared.userUid)
            let updatedData = [
                "isPremium": user.isPremium,
                "premiumDueDate": user.premiumDueDate
            ] as [String : Any]
            try await userRef.setData(updatedData, merge: true)
        } catch {
            print("프리미엄 업데이트 실패: \(error)")
            throw error
        }
    }
    
    func removeUserData(userId: String) async throws {
        do {
            try await FirestoreService.shared.deleteDocument(collectionId: .user, documentId: userId)
        } catch {
            throw error
        }
    }
    
    @MainActor
    func profileUpdate(name: String) async throws {
        guard let user = currentUser else {
            return
        }
        do {
            let userRef = Firestore.firestore().collection("User").document(AuthStore.shared.userUid)
            let updatedData = [
                "userImage" : name/*user.userImage*/
            ]
            try await userRef.setData(updatedData, merge: true)
            print("업데이트 성공")
        } catch {
            print("업데이트 실패: \(error)")
            throw error
        }
    }
}
