//
//  SignUp.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject var signUpstore: SignUpStore
    
    @State private var isPasswordCountError: Bool = false
    @State private var isShowingAlert: Bool = false
    
    
    var body: some View {
        Form {
            Section("회원가입") {
                TextField("이름", text: $signUpstore.nameText)
                TextField("이메일", text: $signUpstore.emailText)
                SecureField("비밀번호를 6자리 이상 입력해주세요", text: $signUpstore.passwordText)
                    .foregroundColor(isPasswordCountError ? .red : .clear)
                SecureField("비밀번호 확인", text: $signUpstore.passwordConfirmText)
                TextField("전화번호", text: $signUpstore.phoneNumText)
            }
            
            Section {
                Button(action: {
                    isShowingAlert = true
                }, label: {
                    Text("완료")
                })
                .alert(isPresented: $isShowingAlert) {
                    Alert(
                        title: Text("로그인 완료"),
                        dismissButton: .default(Text("확인"))
                    )
                }
                .disabled(!signUpstore.checkSignUp() ? true : false)
            }
        }
    }
}


#Preview {
    NavigationStack {
        SignUpView(signUpstore: SignUpStore())
    }
}
