//
//  GoogleSignIn.swift
//  BillBuddy
//
//  Created by 박지현 on 11/11/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignInSwift
import GoogleSignIn
import FirebaseCore

struct GoogleSignInView: View {
    private var googleSignInStore: GoogleSIgnInStore = GoogleSIgnInStore()
    
    var body: some View {
        VStack {
            Button(action: {
                googleSignInStore.handleSignInButton()
            }) {
                HStack {
                    Image(.google)
                    Spacer()
                    Text("구글로 로그인")
                        .font(.body02)
                        .foregroundStyle(Color.systemBlack)
                    Spacer()
                }
            }.padding(20)
                .frame(width: 351, height: 52)
                .background(Color.gray050)
                .cornerRadius(12)
        }
    }
}

#Preview {
    GoogleSignInView()
}
