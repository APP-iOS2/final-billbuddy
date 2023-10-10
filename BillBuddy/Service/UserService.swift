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

final class UserService: ObservableObject {
    @Published var currentUser: User?
    @Published var isSignIn: Bool = false
    
    static let shared = UserService()
    
    private init() {
        Task { try await self.fetchUser() }
        if currentUser != nil {
            isSignIn = true
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
            let user: User = try snapshot.data(as: User.self)
            
            currentUser = user
            isSignIn = true
        } catch {
            print("Error fetching user: \(error)")
            throw error
        }
    }
}
