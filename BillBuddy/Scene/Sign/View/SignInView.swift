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
        VStack {
            Section("로그인") {
                TextField("이메일",text: $signInStore.emailText)
                SecureField("비밀번호", text: $signInStore.passwordText)
            }
            
            Button(action: {
                Task {
                    let result = try await signInStore.checkSignIn()
                    if result {
                        print("넘어가는 뷰")
                    } else {
                        signInStore.isShowingAlert = true
                    }
                }
            }, label: {
                Text("로그인")
            })
            .alert(isPresented: $signInStore.isShowingAlert) {
                Alert(
                    title: Text("로그인 결과"),
                    message: Text("로그인에 실패했습니다."),
                    dismissButton: .default(Text("확인"))
                )
            }
            
            NavigationLink {
                SignUpView(signUpStore: SignUpStore())
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
