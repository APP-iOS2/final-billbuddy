//
//  ForgotPasswordView.swift
//  BillBuddy
//
//  Created by SIKim on 12/15/23.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @EnvironmentObject private var signUpStore: SignUpStore
    @State private var email: String = ""
    @State private var isShowingAlert = false
    @State private var firstLineMessage: String = ""
    @State private var secondLineMessage: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("비밀번호 찾기")
                .padding(.top, 86)
                .font(.title04)
            Group {
                Text("가입한 이메일을 입력해주세요.")
                    .padding(.top, 11)
                Text("해당 이메일로 임시 비밀번호를 보내드려요.")
                    .padding(.bottom, 41)
            }
            .font(.body01)
            
            TextField("이메일", text: $email)
                .padding()
                .font(.body04)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray300, lineWidth: 1)
                )
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            Button(action: {
                Task {
                    if try await AuthStore.shared.sendEmailPasswordReset(email: email) {
                        self.firstLineMessage = "\(email)로 메일이 발송되었어요."
                        self.secondLineMessage = "메일에 기재된 링크를 클릭하여 변경해주세요."
                    } else {
                        self.firstLineMessage = "알 수 없는 오류가 발생했습니다."
                        self.secondLineMessage = "잠시 후 다시 시도해주세요."
                    }
                    isShowingAlert.toggle()
                }
            }, label: {
                Text("임시 비밀번호 전송")
                    .font(.body02)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(signUpStore.isValidEmailId(email) ? Color.myPrimary : Color.gray400)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            })
            .padding(.top, 20)
            .disabled(!signUpStore.isValidEmailId(email))
            
            Spacer()
        }
        .padding(21)
        .randomPasswordAlert(isPresented: $isShowingAlert, firstLineMessage: firstLineMessage, secondLineMessage: secondLineMessage)
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(SignUpStore())
}

