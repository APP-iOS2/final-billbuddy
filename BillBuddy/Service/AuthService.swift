//
//  AuthService.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import Foundation
import FirebaseAuth
import SwiftUI

enum SignInCase {
    case signIn
    case signInFalse
    case fetchFalse
    
    var description: String {
        switch self {
        case .signIn:
            return ""
        case .signInFalse:
            return "아이디와 비밀번호를 확인해주세요"
        case .fetchFalse:
            return "유저정보 불러오기에 실패하였습니다."
        }
    }
}

public class AuthStore {
    @AppStorage("userId") var userUid: String = ""
    @Published var currentUser: User?
    
    static let shared = AuthStore()
    private init() { }
    
    // 신규 사용자
    func createUser(email: String, password: String) async throws -> AuthDataResult {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            print("Sign up successful")
            return authResult
        } catch {
            print("Error occurred when sign up: \(error)")
            throw error
        }
    }
    
    // 기존 사용자
    func signIn(email: String, password: String) async throws -> SignInCase {
        do {
            let signInResult = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userUid = signInResult.user.uid
            try await UserService.shared.fetchUser()
            
            return SignInCase.signIn
        } catch {
            return SignInCase.signInFalse
        }
    }
    
    
    func signOut() throws -> Bool {
        do {
            try Auth.auth().signOut()
            userUid = ""
            currentUser = nil
            print("Log out successful")
            return true
        } catch {
            print("Error logging out: \(error.localizedDescription)")
            return false
        }
    }
    
    func deleteUser() async throws -> Int {
        let user = Auth.auth().currentUser
        
        do {
            try await user?.delete()
            return 0
        } catch {
            let error = error as NSError
            return error.code
        }
    }
    
    func changePassword(password: String) async throws {
        do {
            try await Auth.auth().currentUser?.updatePassword(to: password)
        } catch {
            print("Error changePassword: \(error)")
        }
    }
}
