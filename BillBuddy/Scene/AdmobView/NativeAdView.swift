//
//  NativeAdView.swift
//  BillBuddy
//
//  Created by SIKim on 2023/09/26.
//

import SwiftUI
import GoogleMobileAds

class ViewModel: NSObject, ObservableObject, GADNativeAdLoaderDelegate {
    @Published var nativeAd: GADNativeAd?
    private var adLoader: GADAdLoader!
    
    func refreshAd() {
        adLoader = GADAdLoader(
            adUnitID:
                "ca-app-pub-3940256099942544/3986624511",
            rootViewController: nil,
            adTypes: [.native], options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        self.nativeAd = nativeAd
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}

struct NativeView: UIViewRepresentable {
    typealias UIViewType = GADNativeAdView
    
    @ObservedObject var nativeAdViewModel: ViewModel
    
    func makeUIView(context: Context) -> GADNativeAdView {
        // Link the outlets to the views in the GADNativeAdView.
        return Bundle.main.loadNibNamed(
            "TestView",
            owner: nil,
            options: nil
        )?.first as! GADNativeAdView
    }
    
    func updateUIView(_ nativeAdView: GADNativeAdView, context: Context) {
        guard let nativeAd = nativeAdViewModel.nativeAd else { return }
        
        // Work with your native ad.
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
    }
}

struct NativeAdView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NativeView(nativeAdViewModel: viewModel)
    }
}

#Preview {
    NativeAdView()
}
