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
        
    // 레이아웃 사이즈 설정
        bounds.size = CGSize(width: 46, height: 54)
        centerOffset = CGPoint(x: 0, y: 27)
    }
}

