//
//  SignUpModel.swift
//  BillBuddy
//
//  Created by 박지현 on 10/5/23.
//

import Foundation

struct SignUpData {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var passwordConfirm: String = ""
    var phoneNum: String = ""
    
    func changeToUserModel(id: String) -> User {
        return User(id: id, email: email, name: name, phoneNum: phoneNum, bankName: "", bankAccountNum: "", isPremium: false, premiumDueDate: Date())
    }
}
