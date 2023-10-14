//
//  LocationManager.swift
//  BillBuddyMapKit
//
//  Created by 이승준 on 10/5/23.
//

import Foundation
import CoreLocation
import MapKit

final class LocationManager: NSObject, ObservableObject {
    private var locationManager = CLLocationManager()
    
    @Published var mapView: MKMapView = .init()
    @Published var isChaging: Bool = false
    @Published var selectedAddress: String = ""
    @Published var userLatitude: Double = 0.0
    @Published var userLongitude: Double = 0.0
    
    private var userLocalcity: String = ""
    private var seletedPlace: MKAnnotation?
    
    override init() {
        super.init()
        configure()
        requestAuthorizqtion()
    }
    
    func configure() {
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
    }
    /// 위치 승인
    func requestAuthorizqtion() {
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            moveFocusOnUserLocation()
        case .notDetermined:
            locationManager.startUpdatingLocation()
            locationManager.requestAlwaysAuthorization()
        default: break
        }
    }
}
extension LocationManager {
    
    // MARK: - 사용자 위치로 포인터 이동
    func moveFocusOnUserLocation() {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    // MARK: - 주소로 화면 이동
    func moveFocusChange(location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.01)
        
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - 주소로 검색
    func searchAddress(searchAddress: String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchAddress) { [self] placeMarks, error in
            guard let placeMark = placeMarks?.first, let location = placeMark.location
            else {
                print("주소를 찾을 수 없습니다.")
                return
            }
            print("입력된 주소: \(searchAddress)")
            
            moveFocusChange(location: location.coordinate)
        }
    }
    
    // MARK: - 위도, 경도에 따른 주소 찾기
    func findAddr(location: CLLocation){
        let findLocation = location
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(findLocation, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                var myAdd: String = ""
                if let area: String = address.last?.locality{
                    myAdd += area
                }
                
                if let name: String = address.last?.name {
                    myAdd += " "
                    myAdd += name
                }
                    self.selectedAddress = myAdd
            }
        })
    }
    
    func setAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        
//        for payment in paymentStore.payments {
//            let annotation = MKPointAnnotation()
//            annotation.title = payment.address.address
//            annotation.coordinate = CLLocationCoordinate2D(latitude: payment.address.latitude, longitude: payment.address.longitude)
//            mapView.addAnnotation(annotation)
//        }
        
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways else { return }
        locationManager.requestLocation()
        moveFocusOnUserLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // 현재 위치를 저장
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
}

extension LocationManager: MKMapViewDelegate {
    
    // 이동할 때마다 중앙 핀이 움직이게 하는
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        if !isChaging {
            DispatchQueue.main.async {
                self.isChaging = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        userLatitude = mapView.centerCoordinate.latitude
        userLongitude = mapView.centerCoordinate.longitude
        let location: CLLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
        
//        self.changeToAddress(location: location)
        findAddr(location: location)
        
        DispatchQueue.main.async {
//            print("location: \(location)")
//            print("address: \(self.selectedAddress)")
            self.isChaging = false
        }
    }
}
