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
    
    func checkCurrentPassword(password: String) async -> Bool {
        let user = Auth.auth().currentUser
        var credential: AuthCredential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: password)
        do {
            let authResult = try await user?.reauthenticate(with: credential)
            return true
        } catch {
            print("Error Re-Auth -> \(error)")
            return false
        }
    }
    
    func changePassword(password: String) async throws -> String{
        do {
            try await Auth.auth().currentUser?.updatePassword(to: password)
            return "비밀번호가 변경되었습니다"
        } catch {
            let error = error as NSError
            switch error {
            case AuthErrorCode.weakPassword:
                return "안전성이 낮은 비밀번호입니다"
            case AuthErrorCode.operationNotAllowed:
                return "사용이 중지된 계정입니다"
            case AuthErrorCode.requiresRecentLogin:
                return "인증이 만료되어 재로그인이 필요한 작업입니다"
            default:
                return "알 수 없는 오류가 발생하였습니다"
            }
        }
    }
    
    func sendEmailPasswordReset(email: String) async throws -> Bool {
        do {
            Auth.auth().languageCode = "ko"
            try await Auth.auth().sendPasswordReset(withEmail: email)
            return true
        } catch {
            return false
        }
    }
    
    func checkCurrentUserProviderId() -> Bool {
        guard let providerData = Auth.auth().currentUser?.providerData else { return false }
        for providerInfo in providerData {
            print("제공업체 정보 -> \(providerInfo.providerID)")
            if providerInfo.providerID == "password" {
                return true
            }
        }
        return false
    }
}
