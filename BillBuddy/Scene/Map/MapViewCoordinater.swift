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
        
//        // 기존 라인 제거
//        locationManager.mapView.removeOverlays(locationManager.mapView.overlays)
//        
//        // 라인 그리기
//        for line in locationManager.lines {
//            locationManager.mapView.addOverlay(line.polyline)
//        }
    }
}
