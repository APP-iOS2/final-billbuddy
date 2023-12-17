//
//  SignUpStore.swift
//  BillBuddy
//
//  Created by 박지현 on 2023/09/26.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class SignUpStore: ObservableObject {
    @Published var signUpData = SignUpData()
    
    @Published var isNameTextError: Bool = false
    @Published var isEmailTextError: Bool = false
    @Published var isPasswordUnCorrectError: Bool = false
    @Published var isPasswordCountError: Bool = false
    @Published var isPhoneNumError: Bool = false
    
    @Published var isShowingAlert: Bool = false
    @Published var isEmailValid = true
    
    var showError = false
    
    func checkSignUp() -> Bool {
        if signUpData.name.isEmpty || signUpData.email.isEmpty || signUpData.password.isEmpty || signUpData.passwordConfirm.isEmpty || signUpData.phoneNum.isEmpty || signUpData.isPrivacyAgree == false || signUpData.isTermOfUseAgree == false {
            return false
        }
        return true
    }
    
    // 이메일 형식
    public func isValidEmailId(_ emailText: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: emailText)
    }
    
    // 이메일 중복 검사
    func checkEmailAvailability() {
        Auth.auth().fetchSignInMethods(forEmail: signUpData.email) { methods, error in
            if let error = error {
                print("Error checking email availability: \(error.localizedDescription)")
                return
            }
            
            if methods == nil || methods?.isEmpty == true {
                // 이메일이 사용 가능한 경우
                self.isEmailValid = true
            } else {
                // 이메일이 이미 사용 중인 경우
                self.isEmailValid = false
            }
        }
    }
    
    func saveUserData(user: User) async throws {
        guard let userId = user.id else {
            return
        }
        
        do {
            try await FirestoreService.shared.saveDocument(collection: .user, documentId: userId, data: user)
            print(user)
        } catch {
            throw error
        }
    }
    
    @MainActor
    public func postSignUp() async -> Bool {
        do {
            let authResult = try await AuthStore.shared.createUser(email: signUpData.email, password: signUpData.password )
            var user = signUpData.changeToUserModel(id: authResult.user.uid)
            user.reciverToken = UserService.shared.reciverToken
            try await saveUserData(user: user)
            
            UserDefaults.standard.setValue(authResult.user.uid, forKey: "User")
            return true
        } catch {
            self.isShowingAlert = true
        }
        return false
    }
    
    func deleteUser() async throws {
           do {
               try await UserService.shared.removeUserData(userId: AuthStore.shared.userUid)
           } catch {
               print("deleteUser \(error)")
           }
       }
}
