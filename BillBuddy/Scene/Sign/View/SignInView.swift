//
//  SignIn.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct SignEntry: View {
    var body: some View {
        
            SignInView()
        
    }
}

struct SignInView: View {
    
    @EnvironmentObject private var signInStore: SignInStore
    @FocusState private var isKeyboardUp: Bool
    @State private var isShowingAlert: Bool = false
    @State private var name: String = ""
    @State private var isFirstEntry = false
   
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
                
                GoogleSignInView()
                AppleSignInView()
                
            }
        }
        .fullScreenCover(isPresented: $isFirstEntry) {
            OnboardingView(isFirstEntry: $isFirstEntry)
        }
        .onTapGesture {
            isKeyboardUp = false
        }
        .onReceive(SNSSignInService.shared.$tempUser.receive(on: DispatchQueue.main), perform: { newValue in
            if let newValue {
                if newValue.name == "" {
                    isShowingAlert.toggle()
                } else {
                    SNSSignInService.shared.signInUserFirstTime()
                }
            }
        })
        .padding(24)
        .onAppear {
            self.isFirstEntry = AuthStore.shared.isFirstEntry
            signInStore.emailText = ""
            signInStore.passwordText = ""
        }
        .textFieldAlert(isPresented: $isShowingAlert, textField: $name, message: "이름을 입력하세요", isDismiss: false, action: {
            SNSSignInService.shared.tempUser?.name = name
            SNSSignInService.shared.signInUserFirstTime()
        })
    }
}

#Preview {
    NavigationStack {
        SignInView()
    }
    .environmentObject(SignInStore())
}
