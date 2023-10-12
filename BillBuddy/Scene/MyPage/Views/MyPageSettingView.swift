//
//  MyPageSettingView.swift
//  BillBuddy
//
//  Created by 박지현 on 10/12/23.
//

import SwiftUI

struct MyPageSettingView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    Text("알림 설정")
                        .font(.body04)
                    Spacer()
                    Image("chevron_right")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .padding(.top, 32)
                .padding(.bottom, 36)
                HStack {
                    Text("위치 설정")
                        .font(.body04)
                    Spacer()
                    Image("chevron_right")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .padding(.bottom, 36)
                HStack {
                    Text("개인정보 이용 동의")
                        .font(.body04)
                    Spacer()
                    Image("chevron_right")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .padding(.bottom, 36)
                HStack {
                    Text("문의하기")
                        .font(.body04)
                    Spacer()
                    Image("chevron_right")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .padding(.bottom, 36)
                HStack {
                    Text("오픈소스 라이센스")
                        .font(.body04)
                    Spacer()
                    Image("chevron_right")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .padding(.bottom, 32)
            }
            
            Rectangle()
                .fill(Color.gray050)
                .frame(width: 361, height: 1)
            
            Button(action: {
                //
            }, label: {
                Text("로그아웃")
                    .font(.body04)
                    .foregroundColor(.systemBlack)
            })
            .padding(.top, 32)
            .padding(.bottom, 36)
            
            Button(action: {
                //
            }, label: {
                Text("서비스 탈퇴")
                    .font(.body04)
                    .foregroundColor(.red)
            })
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    NavigationStack {
        MyPageSettingView()
    }
}
