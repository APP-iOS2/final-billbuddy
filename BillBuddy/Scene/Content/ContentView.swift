//
//  ContentView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct ContentView: View {
//    @EnvironmentObject private var schemeServie: SchemeService
  
    @StateObject private var signInStore: SignInStore = SignInStore()
    @StateObject private var signUpStore: SignUpStore = SignUpStore()
    @StateObject private var userService: UserService = .shared

    
    var body: some View {
        //        VStack {
        //            if schemeServie.url == nil {
        //                BillBuddyTabView()
        //            } else {
        //                NavigationStack {
        //                    tempRoomListView()
        //                }
        //            }
        //        }

        if userService.isSignIn {
            BillBuddyTabView()

        } else {
            NavigationStack {
                SignInView(signInStore: signInStore)
                    .environmentObject(signInStore)
                    .environmentObject(signUpStore)
                    .environmentObject(userService)
            }
        }
    }
}



#Preview {
    ContentView()
//        .environmentObject(SchemeService())
}
