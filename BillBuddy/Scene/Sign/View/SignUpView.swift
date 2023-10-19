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
            Text("간편하게 가입하고\n서비스를 이용해보세요.")
                .font(.title05)
                .padding(.bottom, 24)
                .padding(.top, 17)
            
            VStack(alignment: .leading) {
                TextField("이름을 입력해주세요.", text: $signUpStore.signUpData.name)
                    .padding(16)
                    .font(.body04)
                    .autocapitalization(.none)
                    .frame(width: 351, height: 52)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .stroke(signUpStore.isNameTextError ? Color.error : Color.gray300, lineWidth: 2))
                    .cornerRadius(12)
                    .padding(.bottom, signUpStore.isNameTextError ? 0 : 12)
                
                if signUpStore.isNameTextError {
                    Text("이름은 2자리 이상 입력해주세요.")
                        .font(.caption03)
                        .foregroundColor(.error)
                        .padding(.leading, 3)
                        .padding(.bottom, 12)
                }
                
                TextField("이메일을 입력해주세요", text: $signUpStore.signUpData.email)
                    .padding(16)
                    .font(.body04)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .frame(width: 351, height: 52)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .stroke(signUpStore.isEmailTextError ? Color.error : Color.gray300, lineWidth: 2))
                    .cornerRadius(12)
                    .padding(.bottom, signUpStore.isEmailTextError ? 0 : 12)
                
                if signUpStore.isEmailTextError {
                    Text("정확한 이메일을 입력해주세요")
                        .font(.caption03)
                        .foregroundColor(.error)
                        .padding(.leading, 3)
                        .padding(.bottom, 12)
                }
                
                SecureField("비밀번호를 입력해주세요", text: $signUpStore.signUpData.password)
                    .padding(16)
                    .font(.body04)
                    .autocapitalization(.none)
                    .frame(width: 351, height: 52)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .stroke(signUpStore.isPasswordCountError ? Color.error : Color.gray300, lineWidth: 2))
                    .cornerRadius(12)
                    .padding(.bottom, signUpStore.isPasswordCountError ? 0 : 12)
                
                if signUpStore.isPasswordCountError {
                    Text("비밀번호는 6자리 이상 입력해주세요")
                        .font(.caption03)
                        .foregroundColor(.error)
                        .padding(.leading, 3)
                        .padding(.bottom, 12)
                }
                
                SecureField("비밀번호 확인", text:$signUpStore.signUpData.passwordConfirm)
                    .padding(16)
                    .font(.body04)
                    .autocapitalization(.none)
                    .frame(width: 351, height: 52)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .stroke(signUpStore.isPasswordUnCorrectError ? Color.error : Color.gray300, lineWidth: 2))
                    .cornerRadius(12)
                    .padding(.bottom, signUpStore.isPasswordUnCorrectError ? 0 : 12)
                
                if signUpStore.isPasswordUnCorrectError {
                    Text("비밀번호가 서로 다릅니다")
                        .font(.caption03)
                        .foregroundColor(.error)
                        .padding(.leading, 3)
                        .padding(.bottom, 12)
                }
                
                TextField("전화번호를 입력해주세요", text: $signUpStore.signUpData.phoneNum)
                    .padding(16)
                    .font(.body04)
                    .autocapitalization(.none)
                    .frame(width: 351, height: 52)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .stroke(signUpStore.isPhoneNumError ? Color.error : Color.gray300, lineWidth: 2))
                    .cornerRadius(12)
                    .padding(.bottom, signUpStore.isPhoneNumError ? 0 : 12)
                
                if signUpStore.isPhoneNumError {
                    Text("휴대폰 번호 11자리 입력해주세요")
                        .font(.caption03)
                        .foregroundColor(.error)
                        .padding(.leading, 3)
                        .padding(.bottom, 12)
                }
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
                    let isTermOfUseAgreeValid = signUpStore.signUpData.isTermOfUseAgree
                    let isPrivacyAgreeValid = signUpStore.signUpData.isPrivacyAgree
                    
                    if isNameValid && isEmailValid && isPasswordValid && isPasswordConfirmed && isPhoneNumValid && isTermOfUseAgreeValid && isPrivacyAgreeValid {
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
                .alert("회원가입 완료", isPresented: $isShowingAlert) {
                    Button("확인") {
                        dismiss()
                    }
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
        .onAppear {
            signUpStore.signUpData = SignUpData()
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView(signUpStore: SignUpStore())
    }
}
