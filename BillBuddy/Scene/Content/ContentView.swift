//
//  ContentView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var signInStore: SignInStore = SignInStore()
    @StateObject private var signUpStore: SignUpStore = SignUpStore()
    @StateObject private var userService: UserService = .shared
    @StateObject private var schemeServie: SchemeService = .shared
    @StateObject private var userTravelStore = UserTravelStore()
    @StateObject private var settlementExpensesStore = SettlementExpensesStore()
    @StateObject private var chatStore = ChatStore()
    
    var body: some View {
        VStack {
         
            if userService.isSignIn {
                if schemeServie.url == nil {
                    BillBuddyTabView()
                        .environmentObject(settlementExpensesStore)
                        .environmentObject(userTravelStore)
                        .environmentObject(chatStore)
                } else {
                    BillBuddyTabView()
                        .environmentObject(settlementExpensesStore)
                        .environmentObject(userTravelStore)
                        .environmentObject(chatStore)
                }
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
}



#Preview {
    ContentView()
}
