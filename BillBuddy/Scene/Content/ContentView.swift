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
    @StateObject private var invitTravelService: InvitTravelService = .shared
    @StateObject private var userTravelStore = UserTravelStore()
    @StateObject private var settlementExpensesStore = SettlementExpensesStore()
    @StateObject private var messageStore = MessageStore()
    @StateObject private var tabBarVisivilyStore = TabBarVisivilyStore()
    @StateObject private var notificationStore = NotificationStore()
    @StateObject private var nativeViewModel = NativeAdViewModel()
    @StateObject private var myPageStore = MyPageStore()
    @StateObject private var adViewModel = AdViewModel()
    @StateObject private var googleSignIn = GoogleSignInModel()
    @StateObject private var tabViewStore = TabViewStore()
    
    var body: some View {
        if AuthStore.shared.userUid != "" {
            if userService.isSignIn {
                if invitTravelService.isLoading == false {
                    BillBuddyTabView()
                        .environmentObject(settlementExpensesStore)
                        .environmentObject(userTravelStore)
                        .environmentObject(messageStore)
                        .environmentObject(userService)
                        .environmentObject(signInStore)
                        .environmentObject(signUpStore)
                        .environmentObject(tabBarVisivilyStore)
                        .environmentObject(notificationStore)
                        .environmentObject(invitTravelService)
                        .environmentObject(nativeViewModel)
                        .environmentObject(myPageStore)
                        .environmentObject(adViewModel)
                        .environmentObject(tabViewStore)
                        .onAppear {
                            notificationStore.fetchNotification()
                        }
                } else {
                    NavigationStack {
                        LodingView()
                    }
                    .environmentObject(invitTravelService)
                    .environmentObject(tabViewStore)
                    .environmentObject(userTravelStore)
                }
            }
        } else {
            NavigationStack {
                SignInView(signInStore: signInStore)
            }
            .environmentObject(signInStore)
            .environmentObject(signUpStore)
            .environmentObject(userService)
            .environmentObject(googleSignIn)
        }
    }
}



#Preview {
    ContentView()
}
