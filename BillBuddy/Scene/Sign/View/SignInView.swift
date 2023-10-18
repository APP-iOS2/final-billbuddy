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
        VStack(alignment: .leading) {
            Text("간편하게 가입하고\n서비스를 이용해보세요.")
                .font(.title04)
                .padding(.bottom, 24)
            VStack(spacing: 12) {
                TextField("이메일",text: $signInStore.emailText)
                    .padding(16)
                    .frame(width: 351, height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray300, lineWidth: 1))
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                SecureField("비밀번호", text: $signInStore.passwordText)
                    .padding(16)
                    .frame(width: 351, height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray300, lineWidth: 1))
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
                    .font(.body02)
                    .foregroundColor(.white)
            })
            .alert("로그인 결과", isPresented: $signInStore.isShowingAlert) {
                Button("확인") {
                    signInStore.emailText = ""
                    signInStore.passwordText = ""
                }
            } message: {
                Text("로그인에 실패했습니다.")
            }
            .frame(width: 351, height: 52)
            .background(signInStore.emailText.isEmpty || signInStore.passwordText.isEmpty ? Color.gray400 : Color.myPrimary)
            .cornerRadius(12)
            .padding(.top, 20)
            
            NavigationLink {
                SignUpView(signUpStore: SignUpStore())
            } label: {
                Text("이메일 가입")
                    .font(.body04)
                    .foregroundStyle(Color.systemBlack)
            }
            .padding()
        }
        .padding(24)
        .onAppear {
            signInStore.emailText = ""
            signInStore.passwordText = ""
        }
    }
}

#Preview {
    NavigationStack {
        SignInView(signInStore: SignInStore())
    }
}
