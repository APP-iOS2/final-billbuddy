//
//  AddPaymentMapViewCoordinator.swift
//  BillBuddy
//
//  Created by 이승준 on 10/11/23.
//

import Foundation
import SwiftUI
import MapKit

struct AddTravelMapViewCoordinater: UIViewRepresentable {
    
    @ObservedObject var locationManager: LocationManager
    
    func makeUIView(context: Context) -> some UIView {
        return locationManager.mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
