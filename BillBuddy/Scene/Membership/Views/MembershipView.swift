//
//  MembershipView.swift
//  BillBuddy
//
//  Created by SIKim on 10/12/23.
//

import SwiftUI

struct MembershipView: View {
    @EnvironmentObject private var userService: UserService
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingFullScreen: Bool = false
    @State private var isShowingAlert: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    if let user = userService.currentUser {
                        Text(user.isPremium ? "\(user.name)은" : "프리미엄 멤버십을 구독하고")
                        Text(user.isPremium ? "프리미엄 멤버십 구독 중" : "빌버디를 더 유용하게 써보세요")
                    }
                }
                .font(.title05)
                .padding(.top, 54)
                .padding(.horizontal, 8)
                
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray200)
                        .frame(height: 204)
                        .frame(maxWidth: .infinity)
                        .background(Color.clear)
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray1000)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                    VStack(alignment: .leading) {
                        HStack {
                            if let isPremium = userService.currentUser?.isPremium {
                                Text(isPremium ? "아래의 멤버십 혜택을 이용중이에요" : "프리미엄 멤버십 혜택")
                                    .font(.body02)
                                    .foregroundStyle(Color.myPrimary)
                                    .padding(.horizontal, 20)
                                    .padding(.top, 16)
                                    .padding(.bottom, 8)
                            }
                            Spacer()
                        }
                        ZStack(alignment: .topLeading) {
                            Rectangle()
                                .fill(Color.white)
                                .frame(height: 60)
                                .frame(maxWidth: .infinity)
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundStyle(Color.myPrimary)
                                    Text("광고없이 이용해요")
                                        .font(.body04)
                                        .padding(.leading, 7)
                                }
                                .padding(.top, 23)
                                .padding(.leading, 23)
                                
                                HStack {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundStyle(Color.myPrimary)
                                    Text("채팅방에 사진을 첨부할 수 있어요")
                                        .font(.body04)
                                        .padding(.leading, 7)
                                }
                                .padding(.top, 15)
                                .padding(.leading, 23)
                                
                                HStack {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundStyle(Color.myPrimary)
                                    Text("호스트일 떄, 채팅방을 유지할 수 있어요")
                                        .font(.body04)
                                        .padding(.leading, 7)
                                }
                                .padding(.top, 15)
                                .padding(.leading, 23)
                            }
                        }
                    }
                }
                .padding(.horizontal, 5)
                .padding(.top, 28)
                
                if let user = userService.currentUser {
                    if user.isPremium {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray200)
                                .frame(height: 52)
                                .frame(maxWidth: .infinity)
                                .background(Color.clear)
                            HStack {
                                Group {
                                    Text("다음 결제일은")
                                    Text(user.formattedDate)
                                        .foregroundStyle(Color.myPrimary)
                                    Text("입니다.")
                                }
                                .font(.body04)
                                Spacer()
                            }
                            .padding(.leading, 20)
                        }
                        .padding(.top, 4)
                        .padding(.horizontal, 5)
                        
                        Divider()
                            .padding(.top, 108)
                        
                        Button(action: {
                            isShowingAlert.toggle()
                        }, label: {
                            Text("멤버십 해지하기")
                                .font(.body04)
                                .foregroundColor(.error)
                        })
                        .padding(.top, 32)
                        .padding(.horizontal, 8)
                        .alert("멤버십 해지", isPresented: $isShowingAlert) {
                            Button("닫기", role: .cancel) {
                                
                            }
                            Button("해지", role: .destructive) {
                                userService.currentUser?.premiumDueDate = Date()
                                userService.currentUser?.isPremium = false
                                Task {
                                    try await userService.updateUserPremium()
                                }
                            }
                        } message: {
                            Text("프리미엄 멤버십을 해지하시겠습니까?")
                        }
                        
                    } else {
                        Spacer()
                        
                        Button(action: {
                            isShowingFullScreen = true
                        }, label: {
                            Text((userService.currentUser?.isPremium ?? false) ?  "이미 프리미엄 멤버십입니다." : "프리미엄 멤버십 시작하기")
                                .font(.body02)
                                .foregroundColor(.white)
                                .frame(height: 52)
                                .frame(maxWidth: .infinity)
                                .background((userService.currentUser?.isPremium ?? false) ? Color.gray400 : Color.myPrimary)
                                .cornerRadius(12)
                        })
                        .padding(.bottom, 80 - geometry.safeAreaInsets.bottom)
                        .disabled((userService.currentUser?.isPremium ?? false) ? true : false)
                        .fullScreenCover(isPresented: $isShowingFullScreen, content: {
                            TossPaymentsView(isShowingFullScreen: $isShowingFullScreen)
                        })
                    }
                }
            }
            .padding(.horizontal, 16)
        }
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
        .toolbar(.hidden , for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        MembershipView()
            .environmentObject(UserService.shared)
    }
}
