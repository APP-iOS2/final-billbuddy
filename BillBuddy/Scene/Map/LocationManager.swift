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
    
    private let locationManager = CLLocationManager()
    
    @Published var mapView: MKMapView = .init()
    @Published var isChaging: Bool = false
    @Published var selectedAddress: String = ""
    @Published var selectedLatitude: Double = 0.0
    @Published var selectedLongitude: Double = 0.0
    
    private var userLocalcity: String = ""
    private var seletedPlace: MKAnnotation?
    
    override init() {
        super.init()
        configure()
        requestAuthorizqtion()
        registerMapAnnotationView()
    }
    
    func configure() {
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        
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
            
            selectedAddress = searchAddress
            selectedLatitude = location.coordinate.latitude
            selectedLongitude = location.coordinate.longitude
            
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
    
    // 이동할 때마다 중앙 핀이 움직이게 함
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        if !isChaging {
            DispatchQueue.main.async {
                self.isChaging = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        DispatchQueue.main.async {
            self.selectedLatitude = mapView.centerCoordinate.latitude
            self.selectedLongitude = mapView.centerCoordinate.longitude
        }
        let location: CLLocation = CLLocation(latitude: selectedLatitude, longitude: selectedLongitude)
        
        findAddr(location: location)
        
        DispatchQueue.main.async {
            self.isChaging = false
        }
    }
    
    // MARK: - 커스텀한 어노테이션 셋팅
    func setAnnotations(filteredPayments: [Payment]) {
        
        mapView.removeAnnotations(mapView.annotations)
        
        var pinIndex: Int = 1
        
        for payment in filteredPayments {
            let customPinImage = "customPinImage"
            let coordinate = CLLocationCoordinate2D(latitude: payment.address.latitude, longitude: payment.address.longitude)
            let annotation = CustomAnnotation(pinIndex: String(pinIndex), customPinImage: customPinImage, coordinate: coordinate)
            if (coordinate.latitude != 0.0) && (coordinate.longitude != 0.0) {
                mapView.addAnnotation(annotation)
            }
            pinIndex += 1
        }
        getCenterCoordinate(filteredPayments: filteredPayments)
    }
    
    // MARK: - 어노테이션의 사이 좌표로 시야 이동
    func getCenterCoordinate(filteredPayments: [Payment]) {
        let count = Double(filteredPayments.count)
        
        if count > 1 {
            let latitude = filteredPayments.map({ $0.address }).map({ $0.latitude }).reduce(0, +) / count
            let longitude = filteredPayments.map({ $0.address }).map({ $0.longitude }).reduce(0, +) / count
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            moveFocusChange(location: coordinate)
        }
    }
    
    // MARK: - 어노테이션 커스터마이징
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? CustomAnnotation {
            annotationView = setupCustomAnnotationView(for: annotation, on: mapView)
        } else {
            annotationView?.annotation = annotation
        }
        
        // Custom Annotation
        let customPinImage: UIImage!
        customPinImage = UIImage(named: "customPinImage")

        let pinSize = CGSize(width: 46, height: 54)
        UIGraphicsBeginImageContext(pinSize)
        
        customPinImage.draw(in: CGRect(x: 0, y: 0, width: pinSize.width, height: pinSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        
        
        return annotationView
    }
    
    // MARK: - 어노테이션 셋업 및 등록
    private func setupCustomAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        return mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(CustomAnnotation.self), for: annotation)
    }
    
    private func registerMapAnnotationView() {
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
    }
    
    // MARK: - 어노테이션 이미지 선택시 작동하는 함수
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let customAnnotation = view.annotation as? CustomAnnotation {
            moveFocusChange(location: customAnnotation.coordinate)
        }
    }
}

