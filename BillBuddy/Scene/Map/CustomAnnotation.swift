//
//  CustomAnnotation.swift
//  BillBuddy
//
//  Created by 이승준 on 11/17/23.
//

import Foundation
import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    let pinIndex: String
    
    let customPinImage: String
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    init(
        pinIndex: String,
        customPinImage: String,
        coordinate: CLLocationCoordinate2D
    ) {
        self.pinIndex = pinIndex
        self.customPinImage = customPinImage
        self.coordinate = coordinate
    }
}
