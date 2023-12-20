//
//  GoogleSIgnInStore.swift
//  BillBuddy
//
//  Created by SIKim on 12/17/23.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignInSwift
import GoogleSignIn
import FirebaseCore

class GoogleSIgnInStore {
    func handleSignInButton() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self.getRootViewController()) { signResult, error in
            
            if error != nil {
                return
            }
            
            guard let user = signResult?.user, let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            // Use the credential to authenticate with Firebase
            Auth.auth().signIn(with: credential) { result, error in
                //v0roNcPUoGbFjZycF8jWUm266dn1
                guard let userId = result?.user.uid else { return }
                guard let email = result?.user.email else { return }
                let name = result?.user.displayName ?? ""
                
                SNSSignInService.shared.signInUser(userId: userId, name: name, email: email)
            }
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
