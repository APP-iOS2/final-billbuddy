//
//  MyPageSettingView.swift
//  BillBuddy
//
//  Created by 박지현 on 10/12/23.
//

import SwiftUI
import FirebaseAuth
import WebKit

struct MyPageSettingView: View {
    
    @EnvironmentObject private var signInStore: SignInStore
    @EnvironmentObject private var signUpStore: SignUpStore
    @EnvironmentObject private var notificationStore: NotificationStore
    @EnvironmentObject private var userTravelStore: UserTravelStore
    
    @State private var isShowingLogoutAlert: Bool = false
    @State private var isPresentedAlert: Bool = false
    @State private var isReAuthAlert: Bool = false
    @State private var isErrorAlert: Bool = false
    @State private var isCheckingProvider: Bool = AuthStore.shared.checkCurrentUserProviderId()
    
    @State private var isShowingSafari: Bool = false
    private var termsWebView = "https://cut-hospital-213.notion.site/5e186613d1024010ad528f6ade1f09ae?pvs=4"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    NavigationLink(destination: MembershipView()){
                        HStack {
                            Text("프리미엄 멤버십")
                            Spacer()
                            Image("chevron_right")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 36)
                    Button(action: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }, label: {
                        HStack {
                            Text("알림 및 위치 설정")
                            Spacer()
                            Image("chevron_right")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    })
                    .padding(.bottom, 36)
                   
                    Button(action: {
                        isShowingSafari = true
                    }, label: {
                        HStack {
                            Text("개인정보 이용 동의")
                            Spacer()
                            Image("chevron_right")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    })
                    .padding(.bottom, 36)
                    .sheet(isPresented: $isShowingSafari, content: {
                        WebView(url: termsWebView)
                    })

                    Button(action: {
                        if let emailURL = URL(string: "mailto:2023billbuddy@gmail.com") {
                                UIApplication.shared.open(emailURL)
                            }
                    }, label: {
                        HStack {
                            Text("문의하기")
                            Spacer()
                            Image("chevron_right")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    })
                    .padding(.bottom, 36)
                    
                    NavigationLink(destination: LicenseView()){
                        HStack {
                            Text("오픈소스 라이센스")
                            Spacer()
                            Image("chevron_right")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding(.bottom, isCheckingProvider ? 36 : 32)
                    
                    if isCheckingProvider {
                        NavigationLink(destination: ChangePasswordView()){
                            HStack {
                                Text("비밀번호 변경")
                                Spacer()
                                Image("chevron_right")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .padding(.bottom, 32)
                    }
                }
                .font(.body04)
                .foregroundColor(.systemBlack)
                
                Rectangle()
                    .fill(Color.gray050)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                
                Button(action: {
                    isShowingLogoutAlert.toggle()
                }, label: {
                    Text("로그아웃")
                        .font(.body04)
                        .foregroundColor(.systemBlack)
                })
                .padding(.top, 32)
                .padding(.bottom, 36)
                .alert("로그아웃", isPresented: $isShowingLogoutAlert) {
                    Button("취소", role: .cancel) {}
                    Button("로그아웃", role: .destructive) {
                        do {
                            if try AuthStore.shared.signOut() {
                                UserService.shared.isSignIn = false
                                notificationStore.resetStore()
                                userTravelStore.resetStore()
                            }
                        } catch {
                            print("Error signing out: \(error.localizedDescription)")
                        }
                    }
                } message: {
                    Text("로그아웃을 합니다.")
                }
                
                Button(action: {
                    isPresentedAlert.toggle()
                }, label: {
                    Text("서비스 탈퇴")
                        .font(.body04)
                        .foregroundColor(.error)
                })
                .alert("서비스 탈퇴", isPresented: $isPresentedAlert) {
                    Button("취소", role: .cancel) {}
                    Button("탈퇴", role: .destructive) {
                        Task {
                            let resultErrorCode = try await signInStore.deleteUser()
                            if resultErrorCode == 0 {
                                try await signUpStore.deleteUser()
                                UserService.shared.isSignIn = false
                                AuthStore.shared.userUid = ""
                                notificationStore.resetStore()
                                userTravelStore.resetStore()
                            } else if resultErrorCode == AuthErrorCode.requiresRecentLogin.rawValue{
                                isReAuthAlert.toggle()
                            } else {
                                isErrorAlert.toggle()
                            }
                        }
                    }
                } message: {
                    Text("서비스 탈퇴를 합니다.")
                }
                .alert("인증이 만료되어 다시 로그인후 탈퇴해주세요.", isPresented: $isReAuthAlert) {
                    Button("확인") {}
                }
                .alert("알 수 없는 오류가 발생했습니다.", isPresented: $isErrorAlert) {
                    Button("확인") {}
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    NavigationStack {
        MyPageSettingView()
            .environmentObject(SignInStore())
            .environmentObject(SignUpStore())
            .environmentObject(NotificationStore())
            .environmentObject(UserTravelStore())
    }
}
