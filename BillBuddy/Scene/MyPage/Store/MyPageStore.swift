//
//  MyPageStore.swift
//  BillBuddy
//
//  Created by 박지현 on 10/22/23.
//

import Foundation


final class MyPageStore: ObservableObject {
    func isValidBankName(_ bankName: String) -> Bool {
        return (bankName.count >= 2) || (bankName == "")
       }

       func isValidAccountNumber(_ accountNumber: String) -> Bool {
           return (accountNumber.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil) || (accountNumber == "")
       }

       func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
           return (phoneNumber.count == 11) && (phoneNumber.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil) || (phoneNumber == "")
       }

       func isValidEmail(_ email: String) -> Bool {
           let emailRegex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
           return (emailRegex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil) || (email == "")
       }

}
