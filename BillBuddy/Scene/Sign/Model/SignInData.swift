//
//  SignInModel.swift
//  BillBuddy
//
//  Created by 박지현 on 10/4/23.
//

import Foundation

struct SignInData {
    var id: String = UUID().uuidString
    var email: String = ""
    var password: String = ""
    
    func changeToUserModel(id: String) -> User {
        return User(id: id, email: email, name: "", bankName: "", bankAccountNum: "", isPremium: false, premiumDueDate: Date(), reciverToken: "")
    }
}
