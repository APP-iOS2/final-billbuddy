//
//  LocationManager.swift
//  BillBuddy
//
//  Created by 이승준 on 2023/09/27.
//

import Foundation
import MapKit

final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var mapView: MKMapView = .init()
    @Published var annotations: [MKAnnotation] = []
    @Published var lines: [Line] = []
    
    override init() {
        super.init()
        configure()
        requestAuthorizqtion()
        
    }
    
    func configure() {
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestAuthorizqtion() {
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways: 
            break
            
        case .notDetermined:
            locationManager.startUpdatingLocation()
            locationManager.requestAlwaysAuthorization()
        default: break
        }
    }
    
    // MARK: - 주소를 좌표로 바꾸기
    func changeToCoordinate(address: String?) -> (Double?, Double?) {
        var latitude: Double?
        var longitude: Double?
        
        if let address = address {
            CLGeocoder().geocodeAddressString(address) { [weak self] (placemarks, error) in
                guard self != nil else { return }

                if let placemarks = placemarks, let location = placemarks.first?.location {
                    latitude = location.coordinate.latitude
                    longitude = location.coordinate.longitude
                } else {
                    print("주소를 찾을 수 없습니다.")
                }
            }
        }
        return (latitude, longitude)
    }
    
    // MARK: - 입력한 주소에 어노테이션 추가
    func searchAddress(searchText: String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchText) { [self] placeMarks, error in
            guard let placeMark = placeMarks?.first, let location = placeMark.location
            else {
                print("주소를 찾을 수 없습니다.")
                return
            }
            print("입력된 주소: \(searchText)")
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = searchText
            annotations.append(annotation)
            print("어노테이션 추가완료")
            
            if annotations.count >= 2 {
                let line = Line(coordinates: annotations.map { $0.coordinate })
                lines.append(line)
            }
        }
    }
    
}
extension LocationManager: CLLocationManagerDelegate {
    
}

extension LocationManager: MKMapViewDelegate {
    
    // 라인 뷰 제공
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
}
