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

struct GoogleSignIn: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            GoogleSignInButton(action: handleSignInButton)
//            Button(action: {
//                viewModel.signIn()
//            }) {
//                HStack {
//                    Image(.google)
//                    Spacer()
//                    Text("구글로 로그인")
//                        .font(.body02)
//                        .foregroundStyle(Color.systemBlack)
//                    Spacer()
//                }
//            }.padding(20)
//                .frame(width: 351, height: 52)
//                .background(Color.gray050)
//                .cornerRadius(12)
        }
//        .padding()
    }
    
    func handleSignInButton() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self.getRootViewController()) { signResult, error in
            
            if error != nil {
                return
            }
            
            guard let user = signResult?.user,
                  let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            
            _ = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            // Use the credential to authenticate with Firebase
            
        }
        
    }
    
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        
        return root
    }
}

#Preview {
    GoogleSignIn()
}
