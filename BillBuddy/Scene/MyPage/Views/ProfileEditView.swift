//
//  ProfileEditView.swift
//  BillBuddy
//
//  Created by 박지현 on 10/12/23.
//

import SwiftUI

struct ProfileEditView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var myPageStore: MyPageStore
    
    @State private var tempPhoneNum: String = ""
    @State private var phoneNumLabel: String = ""
    @State private var tempEmail: String = ""
    @State private var emailLabel: String = ""
    @State private var tempBankName: String = ""
    @State private var bankNameLabel: String = ""
    @State private var tempBankAccountNum: String = ""
    @State private var bankAccountNumLabel: String = ""
    
    @State private var isShowingAlert = false
    
    @FocusState private var isKeyboardUp: Bool
    
    var body: some View {
        ZStack {
            Color.gray050
            VStack {
                Spacer().frame(height: 8)
                Group {
                    HStack {
                        Text("은행 정보")
                            .font(.body02)
                        Spacer()
                        TextField(text: $tempBankName) {
                            Text(bankNameLabel == "" ? "등록 은행 없음" : bankNameLabel)
                                .foregroundColor(Color.gray600)
                                .focused($isKeyboardUp)
                        }
                        .multilineTextAlignment(.trailing)
                        .font(.body04)
                    }
                    .padding(16)
                    
                    HStack {
                        Text("계좌 정보")
                            .font(.body02)
                        Spacer()
                        TextField(text: $tempBankAccountNum) {
                            Text(bankAccountNumLabel == "" ? "등록 계좌 없음" : bankAccountNumLabel)
                                .foregroundColor(Color.gray600)
                                .focused($isKeyboardUp)
                        }
                        .multilineTextAlignment(.trailing)
                        .font(.body04)
                    }
                    .padding(16)
                    
                    HStack {
                        Text("휴대폰 번호")
                            .font(.body02)
                        Spacer()
                        TextField(text: $tempPhoneNum) {
                            Text(phoneNumLabel)
                                .foregroundColor(Color.gray600)
                                .focused($isKeyboardUp)
                        }
                        .multilineTextAlignment(.trailing)
                        .font(.body04)
                    }
                    .padding(16)
                    
                    HStack {
                        Text("이메일")
                            .font(.body02)
                        Spacer()
                        TextField(text: $tempEmail) {
                            Text(emailLabel)
                                .foregroundColor(Color.gray600)
                                .focused($isKeyboardUp)
                        }
                        .multilineTextAlignment(.trailing)
                        .font(.body04)
                    }
                    .padding(16)
                }
                .frame(width: 361, height: 52)
                .background(.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray100, lineWidth: 1)
                )
                .padding(.top, 16)
                
                
                Spacer()
                
                Button(action: {
                    if myPageStore.isValidBankName(tempBankName) && myPageStore.isValidAccountNumber(tempBankAccountNum) && myPageStore.isValidPhoneNumber(tempPhoneNum) && myPageStore.isValidEmail(tempEmail) {
                        
                        if tempPhoneNum != "" {
                            userService.currentUser?.phoneNum = tempPhoneNum
                        }
                        if tempEmail != "" {
                            userService.currentUser?.email = tempEmail
                        }
                        if tempBankName != "" {
                            userService.currentUser?.bankName = tempBankName
                        }
                        if tempBankAccountNum != "" {
                            userService.currentUser?.bankAccountNum = tempBankAccountNum
                        }
                        Task {
                            do {
                                try await userService.updateUser()
                            } catch {
                                print("업데이트 실패")
                            }
                        }
                        dismiss()
                    } else {
                        isShowingAlert = true
                    }
                }, label: {
                    Text("수정 완료")
                        .font(.title05)
                })
                .frame(maxWidth: .infinity, maxHeight: 83)
                .background(Color.myPrimary)
                .foregroundColor(.white)
                .alert("수정 실패", isPresented: $isShowingAlert) {
                    Button("확인") {
                        dismiss()
                    }
                } message: {
                    Text("입력된 정보가 양식에 맞지 않습니다.")
                }
            }
        }
        .onTapGesture {
            isKeyboardUp = false
        }
        .navigationTitle("프로필 수정")
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
        .onAppear {
            phoneNumLabel = userService.currentUser?.phoneNum ?? ""
            emailLabel = userService.currentUser?.email ?? ""
            bankNameLabel = userService.currentUser?.bankName ?? ""
            bankAccountNumLabel = userService.currentUser?.bankAccountNum ?? ""
            
        }
    }
}

#Preview {
    NavigationStack {
        ProfileEditView()
            .environmentObject(UserService.shared)
            .environmentObject(MyPageStore())
    }
}
