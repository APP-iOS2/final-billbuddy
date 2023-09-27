//
//  SignInStore.swift
//  BillBuddy
//
//  Created by 박지현 on 2023/09/26.
//

import Foundation

final class SignInStore: ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
}
