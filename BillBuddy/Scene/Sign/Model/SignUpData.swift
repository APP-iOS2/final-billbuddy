//
//  SignUpData.swift
//  BillBuddy
//
//  Created by 박지현 on 10/6/23.
//

import Foundation

struct SignUpData {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var passwordConfirm: String = ""

    
    var isPrivacyAgree: Bool = false
    var isTermOfUseAgree: Bool = false
    
    func changeToUserModel(id: String) -> User {
        return User(id: id, email: email, name: name, bankName: "", bankAccountNum: "", isPremium: false, premiumDueDate: Date(), reciverToken: "")
    }
}
