//
//  SignIn.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct SignInView: View {
    
    @ObservedObject var signInStore: SignInStore
    @FocusState private var isKeyboardUp: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("간편하게 가입하고")
                Text("서비스를 이용해보세요.")
                    .padding(.bottom, 24)
            }
            .lineLimit(2)
            .font(.title04)
            VStack(spacing: 12) {
                TextField("이메일",text: $signInStore.emailText)
                    .padding(16)
                    .frame(width: 351, height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray300, lineWidth: 1))
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .focused($isKeyboardUp)
                SecureField("비밀번호", text: $signInStore.passwordText)
                    .padding(16)
                    .frame(width: 351, height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray300, lineWidth: 1))
                    .focused($isKeyboardUp)
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
                    .frame(width: 351, height: 52)
                    .background(signInStore.emailText.isEmpty || signInStore.passwordText.isEmpty ? Color.gray400 : Color.myPrimary)
                    .cornerRadius(12)
            })
            .alert("로그인 결과", isPresented: $signInStore.isShowingAlert) {
                Button("확인") {
                    signInStore.emailText = ""
                    signInStore.passwordText = ""
                }
            } message: {
                Text("로그인에 실패했습니다.")
            }
            .padding(.top, 20)
            
            HStack() {
                Spacer()
                NavigationLink {
                    SignUpView(signUpStore: SignUpStore())
                } label: {
                    Text("이메일 가입")
                }
                
                Spacer()
                Divider()
                    .frame(height: 16)
                Spacer()
                
                NavigationLink {
                    ForgotPasswordView()
                } label: {
                    Text("비밀번호 찾기")
                }
                Spacer()
            }
            .font(.body04)
            .foregroundStyle(Color.systemBlack)
            .padding(.top, 20)
            .padding(.bottom, 30)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("SNS계정으로 로그인")
                    .font(.body02)
                
                GoogleSignIn()
                
                Link(destination: URL(string: "https://naver.com")!, label: {
                    HStack{
                        Image(.naver)
                        Spacer()
                        Text("네이버로 로그인")
                            .font(.body02)
                            .foregroundStyle(Color.white)
                        Spacer()
                    }
                    .padding(20)
                    .frame(width: 351, height: 52)
                    .background(Color.naverSignature)
                    .cornerRadius(12)
                })
                
                AppleSignInView()
                
            }
        }
        .onTapGesture {
            isKeyboardUp = false
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
