//
//  CustomAnnotationView.swift
//  BillBuddy
//
//  Created by 이승준 on 10/17/23.
//

import Foundation
import MapKit

final class CustomAnnotationView: MKAnnotationView {
    static let identifier = "CustomAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
    }
}

final class CustomAnnotation: NSObject, MKAnnotation {
  let customPinImage: UIImage?
  let coordinate: CLLocationCoordinate2D

  init(
    customPinImage: UIImage?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.customPinImage = customPinImage
    self.coordinate = coordinate

    super.init()
  }
}

