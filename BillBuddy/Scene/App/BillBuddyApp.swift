//
//  BillBuddyApp.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        ///모바일 광고 SDK 초기화
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        /// 원격 알림 등록
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        ///메시징 덜리겟
        Messaging.messaging().delegate = self
        
        /// 푸시 포그라운드 설정
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    /// FCM 토근이 등록 되었을대
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

@main
struct BillBuddyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    SchemeService.shared.getUrl(url: url)
                })
        }
    }
}

extension AppDelegate : MessagingDelegate {
    
    /// FCM 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("AppDelegate - 파베 토큰을 받았습니다.")
        print("AppDelegate - Firebase registration token: \(String(describing: fcmToken))")
        UserService.shared.reciverToken = fcmToken ?? ""
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    /// 푸시메시지가 앱이 커져 있을때 나올때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        print("willPresent: userInfo: ", userInfo)
        
        completionHandler([.banner, .sound, .badge])
    }
    
    /// 푸시메시지를 받았을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        print("didReceivet: userInfo: ", userInfo)
        completionHandler()
        
    }
}
