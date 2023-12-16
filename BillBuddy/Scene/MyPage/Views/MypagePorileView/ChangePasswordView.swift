//
//  ChangePasswordView.swift
//  BillBuddy
//
//  Created by SIKim on 12/16/23.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var isUnmatchCurrentPassword: Bool = false
    @State private var isUnmatchNewPassword: Bool = false
    @State private var alertMessage: String = ""
    private var isCorrectPasswordCount: Bool {
        (currentPassword.count > 5) && (newPassword.count > 5) && (confirmNewPassword.count > 5)
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("비밀번호 변경")
                .font(.title04)
                .padding(.top, 25)
            
            Text("비밀번호는 6자리 이상 입력해주세요.")
                .font(.body01)
                .padding(.top, -5)
                .padding(.bottom, 32)
            
            SecureField("현재 비밀번호", text: $currentPassword)
                .padding()
                .font(.body04)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isUnmatchCurrentPassword ? Color.error : Color.gray300, lineWidth: 1)
                )
                .autocapitalization(.none)
                .padding(.bottom, isUnmatchCurrentPassword ? 0 : 24)
            
            if isUnmatchCurrentPassword {
                Text("현재 비밀번호와 일치하지 않습니다")
                    .font(.caption03)
                    .foregroundColor(.error)
                    .padding(.leading, 3)
                    .padding(.bottom, 8)
            }
            
            SecureField("새 비밀번호", text: $newPassword)
                .padding()
                .font(.body04)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray300, lineWidth: 1)
                )
                .autocapitalization(.none)
                .padding(.bottom, 24)
            
            SecureField("새 비밀번호 확인", text: $confirmNewPassword)
                .padding()
                .font(.body04)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isUnmatchNewPassword ? Color.error : Color.gray300, lineWidth: 1)
                )
                .autocapitalization(.none)
                .padding(.bottom, isUnmatchNewPassword ? 0 : 24)
            
            if isUnmatchNewPassword {
                Text("새 비밀번호와 일치하지 않습니다")
                    .font(.caption03)
                    .foregroundColor(.error)
                    .padding(.leading, 3)
                    .padding(.bottom, 8)
            }
            
            Button(action: {
                Task {
                    isUnmatchCurrentPassword = await !AuthStore.shared.checkCurrentPassword(password: currentPassword)
                    isUnmatchNewPassword = (newPassword != confirmNewPassword)
                    
                    if !isUnmatchCurrentPassword && !isUnmatchNewPassword {
                        alertMessage = try await AuthStore.shared.changePassword(password: newPassword)
                        isShowingAlert.toggle()
                    }
                }
            }, label: {
                Text("비밀번호 변경")
                    .font(.body02)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(isCorrectPasswordCount ? Color.myPrimary : Color.gray400)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            })
            .disabled(!isCorrectPasswordCount)
            
            Spacer()
        }
        .padding(21)
        .randomPasswordAlert(isPresented: $isShowingAlert, firstLineMessage: alertMessage, secondLineMessage: "")
        .navigationBarTitleDisplayMode(.inline)
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
        ChangePasswordView()
    }
}
