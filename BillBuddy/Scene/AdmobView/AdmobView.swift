//
//  AdmobView.swift
//  BillBuddy
//
//  Created by SIKim on 2023/09/26.
//

import SwiftUI
import GoogleMobileAds


//struct GADBanner: UIViewControllerRepresentable {
//
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let view = GADBannerView(adSize: GADAdSizeBanner)
//        let viewController = UIViewController()
//        view.adUnitID = "ca-app-pub-3940256099942544/2934735716" // test Key
//        view.rootViewController = viewController
//        viewController.view.addSubview(view)
//        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
//        view.load(GADRequest())
//        return viewController
//    }
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//
//    }
//}


// Delegate methods for receiving width update messages.



struct AdmobView: View {
    //    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            BannerView()
            ///배너광고 뷰
            //                        GADBanner().frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
            //            ///Native 광고 테스트 중
            //                        NativeAdView(nativeAdViewModel: viewModel)
        }
    }
}

#Preview {
    AdmobView()
}
