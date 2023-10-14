//
//  ProfileEditView.swift
//  BillBuddy
//
//  Created by 박지현 on 10/12/23.
//

import SwiftUI

struct ProfileEditView: View {
    
    @EnvironmentObject var userService: UserService
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.gray050
            VStack {
                Spacer().frame(height: 8)
                Group {
                    HStack {
                        Text("계좌 정보")
                            .font(.body02)
                        Spacer()
                        if let bankName = userService.currentUser?.bankName, !bankName.isEmpty {
                            Text(bankName)
                                .foregroundColor(.gray600)
                        } else {
                            Text("등록 계좌 없음")
                                .foregroundColor(.gray600)
                        }
                        Text(userService.currentUser?.bankAccountNum ?? "")
                            .foregroundColor(.gray600)
                    }
                    .font(.body04)
                    .padding(16)

                    HStack {
                        Text("휴대폰 번호")
                            .font(.body02)
                        Spacer()
                        Text(userService.currentUser?.phoneNum ?? "")
                            .font(.body04)
                            .foregroundColor(Color.gray600)
                    }
                    .padding(16)
                    
                    HStack {
                        Text("이메일")
                            .font(.body02)
                        Spacer()
                        Text(userService.currentUser?.email ?? "")
                            .font(.body04)
                            .foregroundColor(Color.gray600)
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
                    
                }, label: {
                    Text("수정하기")
                        .font(.title05)
                })
                .frame(maxWidth: .infinity, maxHeight: 83)
                .background(Color.myPrimary)
                .foregroundColor(.white)
            }
        }
        .navigationTitle("프로필 수정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
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
        ProfileEditView()
            .environmentObject(UserService.shared)
    }
}
