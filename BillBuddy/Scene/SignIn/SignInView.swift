//
//  SignIn.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct SignInView: View {
    
    @ObservedObject var signInStore: SignInStore
    
    var body: some View {
        Form {
            Section("로그인") {
                TextField("이메일", text: $signInStore.emailText)
                SecureField("비밀번호", text: $signInStore.passwordText)
            }
            
            Button {
                //
            } label: {
                Text("로그인")
            }
            
            NavigationLink {
                SignUpView(signUpstore: SignUpStore())
            } label: {
                Text("회원가입")
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignInView(signInStore: SignInStore())
    }
}
