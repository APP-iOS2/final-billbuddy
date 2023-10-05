//
//  SignUp.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject var signUpStore: SignUpStore
    
    @State private var isNameTextError: Bool = false
    @State private var isEmailTextError: Bool = false
    @State private var isPasswordUnCorrectError: Bool = false
    @State private var isPasswordCountError: Bool = false
    
    @State private var isShowingProgressView: Bool = false
    @State private var isShowingAlert: Bool = false
    
    
    var body: some View {
        VStack{
            VStack {
                Text("회원가입")
                Group {
                    TextField("이름", text: $signUpStore.nameText)
                    Text("이름은 2자리 이상 입력해주세요.")
                        .font(.system(size: 10))
                        .foregroundColor(isNameTextError ? .red : .clear)
                }
                Group {
                    TextField("이메일", text: $signUpStore.emailText)
                    Text("정확한 이메일을 입력해주세요")
                        .font(.system(size: 10))
                        .foregroundColor(isEmailTextError ? .red : .clear)
                }
                Group {
                    SecureField("비밀번호를 6자리 이상 입력해주세요", text: $signUpStore.passwordText)
                    Text("비밀번호는 6자리 이상 입력해주세요.")
                        .font(.system(size: 10))
                        .foregroundColor(isPasswordCountError ? .red : .clear)
                }
                Group {
                    SecureField("비밀번호 확인", text: $signUpStore.passwordConfirmText)
                        .border(.red, width: signUpStore.passwordConfirmText != signUpStore.passwordText ? 1 : 0)
                    Text("비밀번호가 서로 다릅니다.")
                        .font(.system(size: 10))
                        .foregroundColor(isPasswordUnCorrectError ? .red : .clear)
                }
                Group {
                    TextField("전화번호", text: $signUpStore.phoneNumText)
                }
                Group {
                    Button(action: {
                        isShowingProgressView = true
                        
                        let isNameValid = signUpStore.nameText.count >= 2
                        let isEmailValid = signUpStore.isValidEmailId(signUpStore.emailText)
                        let isPasswordValid = signUpStore.passwordText.count >= 6
                        let isPasswordConfirmed = signUpStore.passwordConfirmText == signUpStore.passwordText
                        
                        if isNameValid && isEmailValid && isPasswordValid && isPasswordConfirmed {
                            isShowingAlert = true
                        } else {
                            isNameTextError = !isNameValid
                            isEmailTextError = !isEmailValid
                            isPasswordCountError = !isPasswordValid
                            isPasswordUnCorrectError = !isPasswordConfirmed
                        }
                    }, label: {
                        Text("완료")
//                            .background(!signUpStore.checkSignUp() ? .gray : .blue)
                    })
                    .disabled(!signUpStore.checkSignUp() ? true : false)
                    .alert(isPresented: $isShowingAlert) {
                        Alert(
                            title: Text("회원가입 완료"),
                            dismissButton: .default(Text("확인"))
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView(signUpStore: SignUpStore())
    }
}
