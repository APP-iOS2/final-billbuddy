//
//  AdmobBannerView.swift
//  BillBuddy
//
//  Created by SIKim on 10/2/23.
//

import SwiftUI
import GoogleMobileAds

protocol BannerViewControllerWidthDelegate: AnyObject {
    func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat)
}

class BannerViewController: UIViewController {
    weak var delegate: BannerViewControllerWidthDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Tell the delegate the initial ad width.
        delegate?.bannerViewController(
            self, didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width)
    }
    
    override func viewWillTransition(
        to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
    ) {
        coordinator.animate { _ in
            // do nothing
        } completion: { _ in
            // Notify the delegate of ad width changes.
            self.delegate?.bannerViewController(
                self, didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width)
        }
    }
}

struct BannerView: UIViewControllerRepresentable {
    @State private var viewWidth: CGFloat = .zero
    private let bannerView = GADBannerView()
    private let adUnitID = "ca-app-pub-3940256099942544/2934735716"
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerViewController = BannerViewController()
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = bannerViewController
        bannerViewController.view.addSubview(bannerView)
        bannerViewController.delegate = context.coordinator
        
        return bannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard viewWidth != .zero else { return }
        
        // Request a banner ad with the updated viewWidth.
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView.load(GADRequest())
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    internal class Coordinator: NSObject, BannerViewControllerWidthDelegate {
        let parent: BannerView
        
        init(_ parent: BannerView) {
            self.parent = parent
        }
        
        // MARK: - BannerViewControllerWidthDelegate methods
        
        func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat) {
            // Pass the viewWidth from Coordinator to BannerView.
            parent.viewWidth = width
        }
        // MARK: - GADBannerViewDelegate methods
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("\(#function) called")
        }
        
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("\(#function) called")
        }
        
        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
            print("\(#function) called")
        }
        
        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
            print("\(#function) called")
        }
        
        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
            print("\(#function) called")
        }
        
        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
            print("\(#function) called")
        }
    }
}

struct AdmobBannerView: View {
    var body: some View {
        BannerView()
    }
}

#Preview {
    AdmobBannerView()
}
