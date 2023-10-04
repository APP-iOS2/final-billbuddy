//
//  SignInStore.swift
//  BillBuddy
//
//  Created by 박지현 on 2023/09/26.
//

import Foundation
import SwiftUI

final class SignInStore: ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    
    @Published var isSignedIn: Bool = false
    
    @Published var isShowingAlert: Bool = false
    @Published var isDisableSignInButton: Bool = false
    
    @Published var alertDescription: String = ""
    
    func checkSignedIn() -> Bool {
        if AuthStore.userUid.isEmpty {
            isSignedIn = false
            return false
        } else {
            isSignedIn = true
            return true
        }
    }
    
    @MainActor
    func checkSignIn() async throws -> Bool {
        isDisableSignInButton = true
        
        let result = try await AuthStore.signIn(email: emailText, password: passwordText)
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
}
