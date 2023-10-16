//
//  MyPageSettingView.swift
//  BillBuddy
//
//  Created by 박지현 on 10/12/23.
//

import SwiftUI

struct MyPageSettingView: View {
    @State private var isShowingLogoutAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                NavigationLink(destination: ProfileView()){
                    HStack {
                        Text("알림 설정")
                        Spacer()
                        Image("chevron_right")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(.top, 32)
                .padding(.bottom, 36)
                NavigationLink(destination: ProfileView()){
                    HStack {
                        Text("위치 설정")
                        Spacer()
                        Image("chevron_right")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(.bottom, 36)
                NavigationLink(destination: ProfileView()){
                    HStack {
                        Text("개인정보 이용 동의")
                        Spacer()
                        Image("chevron_right")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(.bottom, 36)
                NavigationLink(destination: ProfileView()){
                    HStack {
                        Text("문의하기")
                        Spacer()
                        Image("chevron_right")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(.bottom, 36)
                NavigationLink(destination: ProfileView()){
                    HStack {
                        Text("오픈소스 라이센스")
                        Spacer()
                        Image("chevron_right")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(.bottom, 32)
            }
            .font(.body04)
            .foregroundColor(.systemBlack)
            
            Rectangle()
                .fill(Color.gray050)
                .frame(width: 361, height: 1)
            
            Button(action: {
//                isShowingLogoutAlert.toggle()
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
//        .alert("로그아웃", isPresented: $isShowingLogoutAlert) {
//            Button("취소", role: .cancel) {}
//            Button("로그아웃", role: .destructive) {
//                do {
//                    if try AuthStore.shared.signOut() {
//                        UserService.shared.isSignIn = false
//                    }
//                } catch {
//                    print("Error signing out: \(error.localizedDescription)")
//                }
//            }
//        } message: {
//            Text("로그아웃을 합니다.")
//        }
    }
}

#Preview {
    NavigationStack {
        MyPageSettingView()
    }
}
