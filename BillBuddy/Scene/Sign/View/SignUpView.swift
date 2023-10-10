//
//  SignUp.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject var signUpStore: SignUpStore
    
    @State private var isShowingProgressView: Bool = false
    @State private var isShowingAlert: Bool = false
    
    
    var body: some View {
        VStack{
            VStack {
                Text("회원가입")
                Group {
                    TextField("이름", text: $signUpStore.signUpData.name)
                    Text("이름은 2자리 이상 입력해주세요.")
                        .font(.system(size: 10))
                        .foregroundColor(signUpStore.isNameTextError ? .red : .clear)
                }
                Group {
                    HStack {
                        TextField("이메일", text: $signUpStore.signUpData.email)
                    }
                    Text("정확한 이메일을 입력해주세요")
                        .font(.system(size: 10))
                        .foregroundColor(signUpStore.isEmailTextError ? .red : .clear)
                }
                Group {
                    SecureField("비밀번호를 6자리 이상 입력해주세요", text: $signUpStore.signUpData.password)
                    Text("비밀번호는 6자리 이상 입력해주세요.")
                        .font(.system(size: 10))
                        .foregroundColor(signUpStore.isPasswordCountError ? .red : .clear)
                }
                Group {
                    SecureField("비밀번호 확인", text:$signUpStore.signUpData.passwordConfirm)
                        .border(.red, width: signUpStore.signUpData.passwordConfirm != signUpStore.signUpData.password ? 1 : 0)
                    Text("비밀번호가 서로 다릅니다.")
                        .font(.system(size: 10))
                        .foregroundColor(signUpStore.isPasswordUnCorrectError ? .red : .clear)
                }
                Group {
                    TextField("전화번호", text: $signUpStore.signUpData.phoneNum)
                    Text("휴대폰 번호 11자리 입력해주세요.")
                        .font(.system(size: 10))
                        .foregroundColor(signUpStore.isPhoneNumError ? .red : .clear)
                }
                Group {
                    Button(action: {
                        isShowingProgressView = true
                        
                        let isNameValid = signUpStore.signUpData.name.count >= 2
                        let isEmailValid = signUpStore.isValidEmailId(signUpStore.signUpData.email)
                        let isPasswordValid = signUpStore.signUpData.password.count >= 6
                        let isPasswordConfirmed = signUpStore.signUpData.passwordConfirm == signUpStore.signUpData.password
                        let isPhoneNumValid = signUpStore.signUpData.phoneNum.count == 11
                        
                        if isNameValid && isEmailValid && isPasswordValid && isPasswordConfirmed && isPhoneNumValid {
                            isShowingAlert = true
                            
                            Task {
                                if await signUpStore.postSignUp() {

                                } else {
                                    print("실패")
                                }
                            }
                        } else {
                            signUpStore.isNameTextError = !isNameValid
                            signUpStore.isEmailTextError = !isEmailValid
                            signUpStore.isPasswordCountError = !isPasswordValid
                            signUpStore.isPasswordUnCorrectError = !isPasswordConfirmed
                            signUpStore.isPhoneNumError = !isPhoneNumValid
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
