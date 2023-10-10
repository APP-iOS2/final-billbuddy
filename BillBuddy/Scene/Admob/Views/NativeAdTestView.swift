//
//  NativeAdTestView.swift
//  BillBuddy
//
//  Created by SIKim on 10/9/23.
//

import UIKit
import GoogleMobileAds

class NativeAdTestView: GADNativeAdView {
    let adLabel: UILabel = UILabel()
    let iconImageView: UIImageView = UIImageView()
    let headlineLabel: UILabel = UILabel()
    let advertiserLabel: UILabel = UILabel()
    let ratingImageView: UIImageView = UIImageView()
    let bodyLabel: UILabel = UILabel()
    let adMediaView: GADMediaView = GADMediaView()
    let priceLabel: UILabel = UILabel()
    let storeLabel: UILabel = UILabel()
    let installButton: UIButton = UIButton()
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func draw(_ rect: CGRect) {
        drawView()
    }
    
    func drawView() {
        let safeArea = self.safeAreaLayoutGuide
        
        adLabel.text = "Ad"
        adLabel.font = .systemFont(ofSize: 11.0, weight: .semibold)
        adLabel.textColor = .white
        adLabel.backgroundColor = .systemYellow
        adLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(adLabel)
        
//        adLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 15.0).isActive = true
//        adLabel.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
//        adLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
//        adLabel.rightAnchor.constraint(greaterThanOrEqualTo: safeArea.rightAnchor, constant: 8.0).isActive = true
        adLabel.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        adLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(iconImageView)
        
        iconImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15.0).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        
        headlineLabel.font = .systemFont(ofSize: 17.0)
        headlineLabel.textColor = .darkText
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(headlineLabel)
        
        headlineLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 15.0).isActive = true
        headlineLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8.0).isActive = true
        headlineLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10.0).isActive = true
        headlineLabel.heightAnchor.constraint(equalToConstant: 20.5).isActive = true
        
        
        advertiserLabel.font = .systemFont(ofSize: 14.0)
        advertiserLabel.textColor = .darkText
        advertiserLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(advertiserLabel)
        
        advertiserLabel.trailingAnchor.constraint(greaterThanOrEqualTo: safeArea.trailingAnchor, constant: 10.0).isActive = true
        advertiserLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor).isActive = true
        
        
        
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(ratingImageView)
        
        ratingImageView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        ratingImageView.leadingAnchor.constraint(equalTo: advertiserLabel.trailingAnchor).isActive = true
        ratingImageView.heightAnchor.constraint(equalToConstant: 17.0).isActive = true
        ratingImageView.centerYAnchor.constraint(equalTo: advertiserLabel.centerYAnchor).isActive = true
        ratingImageView.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor).isActive = true
        ratingImageView.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 8.0).isActive = true
        
        
        bodyLabel.font = .systemFont(ofSize: 14.0)
        bodyLabel.textColor = .darkText
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bodyLabel)
        
        bodyLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 10.0).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor).isActive = true
        bodyLabel.topAnchor.constraint(greaterThanOrEqualTo: iconImageView.bottomAnchor, constant: 0).isActive = true
        bodyLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 8.0).isActive = true
        
        
        adMediaView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(adMediaView)
        
        adMediaView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        adMediaView.widthAnchor.constraint(equalToConstant: 250.0).isActive = true
        adMediaView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        adMediaView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 5.0).isActive = true
        
        
        priceLabel.font = .systemFont(ofSize: 14.0)
        priceLabel.textColor = .darkText
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(priceLabel)
        
        priceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: safeArea.leadingAnchor, constant: 10.0).isActive = true
        
        
        storeLabel.font = .systemFont(ofSize: 14.0)
        storeLabel.textColor = .darkText
        storeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(storeLabel)
        
        storeLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10.0).isActive = true
        storeLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor).isActive = true
        
        
        installButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(installButton)
        
        installButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 10.0).isActive = true
        installButton.leadingAnchor.constraint(equalTo: storeLabel.trailingAnchor, constant: 10.0).isActive = true
        installButton.bottomAnchor.constraint(greaterThanOrEqualTo: safeArea.bottomAnchor, constant: 8.0).isActive = true
        installButton.centerYAnchor.constraint(equalTo: storeLabel.centerYAnchor).isActive = true
        installButton.topAnchor.constraint(equalTo: adMediaView.bottomAnchor, constant: 10.0).isActive = true
    }
}
