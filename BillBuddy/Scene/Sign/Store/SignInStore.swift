//
//  SignInStore.swift
//  BillBuddy
//
//  Created by 박지현 on 2023/09/26.
//

import Foundation
import SwiftUI

final class SignInStore: ObservableObject {
    @Published var signInData = SignInData()
    
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    
    @Published var isSignedIn: Bool = false
    
    @Published var isShowingAlert: Bool = false
    @Published var isDisableSignInButton: Bool = false
    
    @Published var alertDescription: String = ""
    
    @MainActor
    func checkSignIn() async throws -> Bool {
        isDisableSignInButton = true
        
        let result = try await AuthStore.shared.signIn(email: emailText, password: passwordText)
        self.alertDescription = result.description
        
        switch result {
        case .signIn:
            isSignedIn = true
            return true
        default:
            isShowingAlert = true
            return false
        }
    }
    
    func checkSignIn() -> Bool {
        if signInData.email.isEmpty || signInData.password.isEmpty {
            return false
        }
        return true
    }
    
    @MainActor
    func deleteUser() async throws -> Int{
        return try await AuthStore.shared.deleteUser()
    }
}
