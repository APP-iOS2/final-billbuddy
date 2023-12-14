//
//  CustomAnnotationView.swift
//  BillBuddy
//
//  Created by 이승준 on 10/17/23.
//

import Foundation
import SwiftUI
import MapKit

final class CustomAnnotationView: MKAnnotationView {
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [customImageView, pinIndexLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    lazy var customImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "customPinImage")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var pinIndexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "INDEX"
        label.textColor = .primary2
        label.textAlignment = .center
        return label
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        setUpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLayout() {
        
        addSubview(stackView)

        NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: topAnchor),
                    stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    
                    pinIndexLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -15),
                    
                    customImageView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 0)
                ])

//        NSLayoutConstraint.activate([
//            
//            backgroundUIView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            backgroundUIView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            backgroundUIView.topAnchor.constraint(equalTo: self.topAnchor),
//            backgroundUIView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            
//            customImageView.leadingAnchor.constraint(equalTo: backgroundUIView.leadingAnchor),
//            customImageView.trailingAnchor.constraint(equalTo: backgroundUIView.trailingAnchor),
//            customImageView.topAnchor.constraint(equalTo: backgroundUIView.topAnchor),
//            customImageView.bottomAnchor.constraint(equalTo: backgroundUIView.bottomAnchor),
//            
//            stackView.leadingAnchor.constraint(equalTo: backgroundUIView.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: backgroundUIView.trailingAnchor),
//            stackView.topAnchor.constraint(equalTo: backgroundUIView.topAnchor),
//            stackView.bottomAnchor.constraint(equalTo: backgroundUIView.bottomAnchor),
//        
//            
//            pinIndexLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
//            pinIndexLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor),
//            pinIndexLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
//            pinIndexLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
//            
//        ])
        
       
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        customImageView.image = nil
        pinIndexLabel.text = nil
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        guard let annotation = annotation as? CustomAnnotation else { return }
        
        pinIndexLabel.text = String(annotation.pinIndex)
        
        let image = UIImage(named: "customPinImage")
        
        customImageView.image = image
        
        setNeedsLayout()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

