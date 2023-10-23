import GoogleMobileAds
import SwiftUI

struct AdContentView: View {
    @EnvironmentObject private var adViewModel: AdViewModel
    @State private var adSecond = 3
    @Binding var isShowingAdScreen: Bool
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var isOnNativeAd: Bool {
        return adSecond > -1
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                AdView(adViewModel: adViewModel)
                    .frame(height: 300)
                
                Text(
                    adViewModel.ad?.mediaContent.hasVideoContent == true
                    ? "Ad contains a video asset." : "Ad does not contain a video."
                )
                .frame(maxWidth: .infinity)
                .foregroundColor(.gray)
                .opacity(adViewModel.ad == nil ? 0 : 1)
                
                Button("Refresh Ad") {
                    refreshAd()
                }
                
                Text(
                    "SDK Version:"
                    + "\(GADGetStringFromVersionNumber(GADMobileAds.sharedInstance().versionNumber))")
            }
            .padding()
            .onAppear {
                refreshAd()
            }
            .onReceive(timer, perform: { _ in
                if isOnNativeAd {
                    adSecond -= 1
                }
            })
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        isShowingAdScreen = false
                    }, label: {
                        Text(isOnNativeAd ? "\(adSecond)" : "닫기")
                    })
                    .disabled(isOnNativeAd)
                }
            }
        }
    }
    
    private func refreshAd() {
        adViewModel.refreshAd()
    }
}

#Preview {
    AdContentView(isShowingAdScreen: .constant(true))
}

private struct AdView: UIViewRepresentable {
    typealias UIViewType = GADNativeAdView
    
    @ObservedObject var adViewModel: AdViewModel
    
    func makeUIView(context: Context) -> GADNativeAdView {
        return
        Bundle.main.loadNibNamed(
            "AdView",
            owner: nil,
            options: nil)?.first as! GADNativeAdView
    }
    
    func updateUIView(_ adView: GADNativeAdView, context: Context) {
        guard let ad = adViewModel.ad else { return }
        
        (adView.headlineView as? UILabel)?.text = ad.headline
        
        adView.mediaView?.mediaContent = ad.mediaContent
        
        (adView.bodyView as? UILabel)?.text = ad.body
        
        (adView.iconView as? UIImageView)?.image = ad.icon?.image
        
        (adView.starRatingView as? UIImageView)?.image = imageOfStars(from: ad.starRating)
        
        (adView.storeView as? UILabel)?.text = ad.store
        
        (adView.priceView as? UILabel)?.text = ad.price
        
        (adView.advertiserView as? UILabel)?.text = ad.advertiser
        
        (adView.callToActionView as? UIButton)?.setTitle(ad.callToAction, for: .normal)
        
        // In order for the SDK to process touch events properly, user interaction should be disabled.
        adView.callToActionView?.isUserInteractionEnabled = false
        
        // Associate the native ad view with the native ad object. This is required to make the ad clickable.
        // Note: this should always be done after populating the ad views.
        adView.nativeAd = ad
    }
    
    private func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
            return nil
        }
        if rating >= 5 {
            return UIImage(named: "stars_5")
        } else if rating >= 4.5 {
            return UIImage(named: "stars_4_5")
        } else if rating >= 4 {
            return UIImage(named: "stars_4")
        } else if rating >= 3.5 {
            return UIImage(named: "stars_3_5")
        } else {
            return nil
        }
    }
}

final class AdViewModel: NSObject, ObservableObject, GADNativeAdLoaderDelegate {
    @Published var ad: GADNativeAd?
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
    
    func adLoader(_ adLoader: GADAdLoader, didReceive ad: GADNativeAd) {
        self.ad = ad
        ad.delegate = self
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}

// MARK: - GADNativeAdDelegate implementation
extension AdViewModel: GADNativeAdDelegate {
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
}
