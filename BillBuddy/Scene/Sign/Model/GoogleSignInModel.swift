//
//  GoogleSignInModel.swift
//  BillBuddy
//
//  Created by 박지현 on 11/11/23.
//

import Foundation
import SwiftUI
import Firebase
import GoogleSignIn

class GoogleSignInModel: ObservableObject {
    // 로그인 한 상태와 로그인 하지 않은 상태로 분류한다.
    enum SignState {
        case signedIn
        case signedOut
    }
    
    // 초기에는 로그아웃한 상태로 시작
    @Published var state: SignState = .signedOut
    
    func check() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                // 복구하면서 user 정보를 받아온다.
                state = .signedIn
                authenticateUser(for: user, with: error)
            }
        } else {
            state = .signedOut
        }
    }
    
    func signIn() {
        // 이전에 로그인 했는지 검사
        // 이전에 로그인 했으면 그 기억을 복구하고, 없으면 로그인을 시도한다.
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                // 복구하면서 user 정보를 받아온다.
                state = .signedIn
                authenticateUser(for: user, with: error)
            }
        } else {
            // google service info.plist에서 clientId 값을 가져온다.
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            // Start the sign in flow!
            GIDSignIn.sharedInstance.signIn(withPresenting: self.getRootViewController()) { result, error in
                guard error == nil else {
                    return
                }
                
                self.state = .signedIn
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString
                else {
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)
                
            }
        }
    }
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        // user 객체로부터 idToken과 accessToken을 가져온다.
        guard let accessToken = user?.accessToken.tokenString,
              let idToken = user?.idToken?.tokenString else {
            return
            
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.state = .signedIn
            }
        }
    }
    
    // 로그아웃
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        
        do {
            try Auth.auth().signOut()
            
            state = .signedOut
        } catch {
            print(error.localizedDescription)
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
