//
//  SignUpStore.swift
//  BillBuddy
//
//  Created by 박지현 on 2023/09/26.
//

import Foundation

final class SignUpStore: ObservableObject {
    @Published var nameText: String = ""
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var passwordConfirmText: String = ""
    @Published var phoneNumText: String = ""
    
    func checkSignUp() -> Bool {
        if nameText.isEmpty || emailText.isEmpty || passwordText.isEmpty || passwordConfirmText.isEmpty || phoneNumText.isEmpty {
            return false
        }
        return true
    }

}
