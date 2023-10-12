//
//  ProfileView.swift
//  BillBuddy
//
//  Created by 박지현 on 10/11/23.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var myPageStore: MyPageStore
    
    var body: some View {
        VStack {
            HStack {
                Image(myPageStore.myPageData.userImage)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(50)
                VStack(alignment: .leading) {
                    Text(myPageStore.myPageData.name)
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
                    Text(myPageStore.myPageData.bankName)
                        .foregroundColor(.gray600)
                    Text(myPageStore.myPageData.bankAccountNum)
                        .foregroundColor(.gray600)
                    Button(action: {
                        UIPasteboard.general.string = myPageStore.myPageData.bankName + " " + myPageStore.myPageData.bankAccountNum
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
                    Text(myPageStore.myPageData.phoneNum)
                        .foregroundColor(.gray600)
                }
                HStack {
                    Text("이메일 주소")
                    Spacer()
                    Text(myPageStore.myPageData.email)
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
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("arrow_back")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.systemBlack)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ProfileEditView(myPageStore: MyPageStore())) {
                    Text("수정")
                        .font(.body01)
                        .foregroundColor(.systemBlack)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(myPageStore: MyPageStore())
    }
}
