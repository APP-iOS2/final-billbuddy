//
//  MembershipView.swift
//  BillBuddy
//
//  Created by SIKim on 10/12/23.
//

import SwiftUI

struct MembershipView: View {
    @EnvironmentObject private var userService: UserService
    @State private var isShowingFullScreen: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Button(action: {
                    isShowingFullScreen = true
                }, label: {
                    Text((userService.currentUser?.isPremium ?? false) ?  "이미 프리미엄 멤버십입니다." : "프리미엄 가입")
                        .font(.body02)
                        .foregroundColor(.white)
                        .frame(height: 52)
                        .frame(maxWidth: .infinity)
                        .background((userService.currentUser?.isPremium ?? false) ? Color.gray400 : Color.myPrimary)
                        .cornerRadius(12)
                })
                .padding(.horizontal, 21)
                .padding(.bottom, 80 - geometry.safeAreaInsets.bottom)
                .disabled((userService.currentUser?.isPremium ?? false) ? true : false)
                .fullScreenCover(isPresented: $isShowingFullScreen, content: {
                    TossPaymentsView(isShowingFullScreen: $isShowingFullScreen)
                })
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        MembershipView()
    }
}
