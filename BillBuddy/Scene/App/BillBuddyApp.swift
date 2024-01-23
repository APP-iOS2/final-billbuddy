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
import GoogleSignIn
import UserNotifications

@main
struct BillBuddyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var showingUpdate: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .alert("새로운 버전 업데이트가 있어요", isPresented: $showingUpdate) {
                    Button(action: {
                        openAppStore()
                    }, label: {
                        Text("앱스토어로 이동")
                    })
                }
                .task {
                    if await AppStoreUpdateChecker.isNewVersionAvailable() {
                        showingUpdate.toggle()
                    }
                }
        }
    }
    private func openAppStore() {
        guard let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/apple-store/6474726564") else { return }
        if UIApplication.shared.canOpenURL(appStoreURL) {
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
        }
    }
}

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
    
    // Google SignIn
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
    -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

extension AppDelegate : MessagingDelegate {
    
    /// FCM 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("AppDelegate - 파베 토큰을 받았습니다.")
        print("AppDelegate - Firebase registration token: \(String(describing: fcmToken))")
        UserService.shared.getReciverToken(fcmToken ?? "nil")
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    /// 푸시메시지가 앱이 커져 있을때 나올때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // - 앱이 실행되는 도중에 알림이 도착하는 경우에 발생하므로 앱이 실행하는 도중에 알림이 도착했는지 확인을 할수 있습니다.
        // - 만약 앱 실행중에도 알림배너를 표시해주고 싶으면, 이 메서드를 구현하면됩니다.
        let userInfo = notification.request.content.userInfo
        
        // TODO: fetch -> 받아온 데이터로 add만 해주는 형식으로 바꿔야한다.
        NotificationStore.shared.fetchNotification()
        
        if let senderToken = userInfo["senderToken"] as? String {
            let currentUserToken = UserService.shared.reciverToken
            
            if senderToken != currentUserToken {
                if TabViewStore.shared.isPresentedView {
                    completionHandler([])
                } else {
                    completionHandler([.banner, .sound, .badge])
                }
            } else {
                completionHandler([])
            }
        } else {
            completionHandler([.banner, .sound, .badge])
        }
    }
    
    /// 푸시메시지를 받았을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // - 앱이 실행, 미실행 둘다 상관없이 로컬알림을 클릭했을때 동일하게 호출됩니다.
        let userInfo = response.notification.request.content.userInfo
        
        print("didReceivet: userInfo: ", userInfo)
        TabViewStore.shared.pushNotificationListView()
        completionHandler()
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // 푸시 알림이 도착하면 호출되는 부분
        // MARK: Fetch 되도록!!!
        
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // 세로방향 고정
        return UIInterfaceOrientationMask.portrait
    }
}
