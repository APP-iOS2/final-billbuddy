//
//  SignUp.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var signUpStore: SignUpStore
    
    @State private var isShowingProgressView: Bool = false
    @State private var isShowingAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("간편하게 가입하고\n서비스를 이용해보세요.")
                .font(.title05)
                .padding(.bottom, 24)
            VStack {
                TextField("이름을 입력해주세요.", text: $signUpStore.signUpData.name)
                    .padding(16)
                    .frame(width: 351, height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray300, lineWidth: 1))
                
                Text("이름은 2자리 이상 입력해주세요.")
                    .font(.system(size: 10))
                    .foregroundColor(signUpStore.isNameTextError ? .red : .clear)
                
                TextField("이메일을 입력해주세요.", text: $signUpStore.signUpData.email)
                    .padding(16)
                    .frame(width: 351, height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray300, lineWidth: 1))
                
                Text("정확한 이메일을 입력해주세요")
                    .font(.system(size: 10))
                    .foregroundColor(signUpStore.isEmailTextError ? .red : .clear)
                
                SecureField("비밀번호를 입력해주세요", text: $signUpStore.signUpData.password)
                    .padding(16)
                    .frame(width: 351, height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray300, lineWidth: 1))
                
                Text("비밀번호는 6자리 이상 입력해주세요.")
                    .font(.system(size: 10))
                    .foregroundColor(signUpStore.isPasswordCountError ? .red : .clear)
                
                SecureField("비밀번호 확인", text:$signUpStore.signUpData.passwordConfirm)
                    .padding(16)
                    .frame(width: 351, height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray300, lineWidth: 1))
                
                Text("비밀번호가 서로 다릅니다.")
                    .font(.system(size: 10))
                    .foregroundColor(signUpStore.isPasswordUnCorrectError ? .red : .clear)
                
                TextField("전화번호를 입력해주세요", text: $signUpStore.signUpData.phoneNum)
                    .padding(16)
                    .frame(width: 351, height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray300, lineWidth: 1))
                
                Text("휴대폰 번호 11자리 입력해주세요.")
                    .font(.system(size: 10))
                    .foregroundColor(signUpStore.isPhoneNumError ? .red : .clear)
            }
            
            AgreementCheckButton(agreement: $signUpStore.signUpData.isTermOfUseAgree, text: "이용약관에 동의합니다.(필수)")
            AgreementCheckButton(agreement: $signUpStore.signUpData.isPrivacyAgree, text: "개인정보 취급방침에 동의합니다.(필수)")
            
            Spacer()
            
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
                    Text("가입하기")
                        .font(.body02)
                        .foregroundColor(.white)
                })
                .frame(width: 351, height: 52)
                .background(Color.myPrimary)
                .cornerRadius(12)
                .disabled(!signUpStore.checkSignUp() ? true : false)
                .disabled(!signUpStore.signUpData.isPrivacyAgree && signUpStore.signUpData.isTermOfUseAgree)
                .alert(isPresented: $isShowingAlert) {
                    Alert(
                        title: Text("회원가입 완료"),
                        dismissButton: .default(Text("확인"))
                    )
                }
            }
        }
        .padding(.horizontal, 24)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image("arrow_back")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.systemBlack)
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
