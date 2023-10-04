//
//  SignUpStore.swift
//  BillBuddy
//
//  Created by 박지현 on 2023/09/26.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

final class SignUpStore: ObservableObject {
    @Published var nameText: String = ""
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var passwordConfirmText: String = ""
    @Published var phoneNumText: String = ""
    
    var isTextError: Bool = false
    var isPasswordUnCorrectError: Bool = false
    var isPasswordCountError: Bool = false
    var isShowingAlert: Bool = false
    
    var showError = false
    
    func checkSignUp() -> Bool {
        if nameText.isEmpty || emailText.isEmpty || passwordText.isEmpty || passwordConfirmText.isEmpty || phoneNumText.isEmpty {
            return false
        }
        return true
    }
    
    // 이메일 형식
    public func isValidEmailId(_ emailText: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: emailText)
    }
}
