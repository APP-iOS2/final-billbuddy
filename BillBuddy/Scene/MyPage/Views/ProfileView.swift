//
//  ProfileView.swift
//  BillBuddy
//
//  Created by 박지현 on 10/11/23.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var userService: UserService
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    // 버튼 눌리면 수정
                } label: {
                    Image(userService.currentUser?.userImage ?? "white")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .cornerRadius(50)
                }
                VStack(alignment: .leading) {
                    Text(userService.currentUser?.name ?? "")
                        .font(.body01)
                        .padding(.bottom, 8)
                    Text("애플 계정 연결중")
                        .font(.caption02)
                        .foregroundColor(.gray600)
                }
                .padding(16)
                Spacer()
            }
            .padding(.bottom, 36)
            
            Group {
                HStack {
                    Text("계좌 정보")
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
                    Button(action: {
                        let bankName = userService.currentUser?.bankName ?? ""
                        let bankAccountNum = userService.currentUser?.bankAccountNum ?? ""
                        let combinedString = bankName + " " + bankAccountNum
                        UIPasteboard.general.string = combinedString
                    }, label: {
                        Image("multiple-file-1-5")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.gray600)
                            .frame(width: 18, height: 18)
                    })
                }
                HStack {
                    Text("휴대폰 번호")
                    Spacer()
                    Text(userService.currentUser?.phoneNum ?? "")
                        .foregroundColor(.gray600)
                }
                HStack {
                    Text("이메일 주소")
                    Spacer()
                    Text(userService.currentUser?.email ?? "")
                        .foregroundColor(.gray600)
                }
            }
            .font(.body04)
            .padding(.bottom, 36)
            Spacer()
        }
        .padding(24)
        .navigationTitle("내 프로필")
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
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ProfileEditView()) {
                    Text("수정")
                        .font(.body01)
                        .foregroundColor(.systemBlack)
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(UserService.shared)
    }
}
