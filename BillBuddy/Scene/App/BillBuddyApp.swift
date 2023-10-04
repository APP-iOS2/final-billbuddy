//
//  BillBuddyApp.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        ///모바일 광고 SDK 초기화
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
}

@main
struct BillBuddyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var schemeServie: SchemeService = SchemeService()
    @StateObject private var userTravelStore = UserTravelStore()
  
    var body: some Scene {

        WindowGroup {
            ContentView()
                .environmentObject(userTravelStore)
                .environmentObject(schemeServie)
                .onOpenURL(perform: { url in
                    schemeServie.getUrl(url: url)
                })
        }
    }
}
