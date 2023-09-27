//
//  NativeAdView.swift
//  BillBuddy
//
//  Created by SIKim on 2023/09/26.
//

import SwiftUI
import GoogleMobileAds

//struct NativeAdView: UIViewRepresentable {
//    typealias UIViewType = GADNativeAdView
//    
//    @ObservedObject var nativeAdViewModel: ViewModel
//    
//    func makeUIView(context: Context) -> GADNativeAdView {
//        // Link the outlets to the views in the GADNativeAdView.
//        return Bundle.main.loadNibNamed(
//            "NativeAdView",
//            owner: nil,
//            options: nil)?.first as! GADNativeAdView
//    }
//    
//    func updateUIView(_ nativeAdView: GADNativeAdView, context: Context) {
//        guard let nativeAd = nativeAdViewModel.nativeAd else { return }
//        
//        // Work with your native ad.
//        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
//    }
//}
//
//class ViewModel: NSObject, ObservableObject, GADNativeAdLoaderDelegate {
//    @Published var nativeAd: GADNativeAd?
//    private var adLoader: GADAdLoader!
//    
//    func refreshAd() {
//        adLoader = GADAdLoader(
//            adUnitID:
//                "ca-app-pub-3940256099942544/3986624511",
//            rootViewController: nil,
//            adTypes: [.native], options: nil)
//        adLoader.delegate = self
//        adLoader.load(GADRequest())
//    }
//    
//    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
//        self.nativeAd = nativeAd
////        nativeAd.delegate = self
//    }
//    
//    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
//        print("\(adLoader) failed with error: \(error.localizedDescription)")
//    }
//    
//    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
//        print("\(#function) called")
//    }
//    
//    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
//        print("\(#function) called")
//    }
//    
//    func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
//        print("\(#function) called")
//    }
//    
//    func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
//        print("\(#function) called")
//    }
//    
//    func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
//        print("\(#function) called")
//    }
//}
