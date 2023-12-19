//
//  AppleSignInView.swift
//  BillBuddy
//
//  Created by 박지현 on 12/14/23.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct AppleSignInView: View {
    @Environment(\.window) var window: UIWindow?
    @State private var appleLoginCoordinator: AppleSignInStore?
    
    var body: some View {
        HStack{
            Image(.apple)
            Spacer()
            Text("애플로 로그인")
                .font(.body02)
                .foregroundStyle(Color.white)
            Spacer()
        }
        .padding(20)
        .frame(width: 351, height: 52)
        .background(Color.systemBlack)
        .cornerRadius(12)
        .onTapGesture {
            appleSignin()
        }
    }
    
    func appleSignin() {
        appleLoginCoordinator = AppleSignInStore(window: window)
        appleLoginCoordinator?.startAppleSignIn()
    }
}

#Preview {
    AppleSignInView()
}
