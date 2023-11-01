//
//  MapViewCoordinater.swift
//  BillBuddy
//
//  Created by 이승준 on 2023/09/27.
//

import Foundation
import SwiftUI
import MapKit

struct MapViewCoordinater: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager
    
    func makeUIView(context: Context) -> some UIView {
        return locationManager.mapView
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
