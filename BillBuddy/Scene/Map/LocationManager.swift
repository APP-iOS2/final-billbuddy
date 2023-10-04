//
//  LocationManager.swift
//  BillBuddy
//
//  Created by 이승준 on 2023/09/27.
//
import CoreLocation
import Foundation
import MapKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var mapView: MKMapView = .init()
    @Published var placeList: [Place] = []
    @Published var annotations: [MKAnnotation] = []
    @Published var lines: [Line] = []
    @Published var isChaging: Bool = false
    
    private var searchResult: [Place] = []
    
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
    
    func fetchAnotations() {
        Task {
            do {
                let snapshots = try await Firestore.firestore().collection("Place").getDocuments()
                
                print(snapshots.documents.count)
                var places: [Place] = []
                try snapshots.documents.forEach { snapshot in
                    do {
                        let place = try snapshot.data(as: Place.self)
                        places.append(place)
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                    }
                }
                print(places)
                searchResult = places
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    
    // MARK: - 주소를 좌표로 바꾸기
    func changeToCoordinate(address: String?) -> (Double?, Double?) {
        var latitude: Double?
        var longitude: Double?
        
        if let address = address {
            CLGeocoder().geocodeAddressString(address) { [weak self] (placemarks, error) in
                guard let self = self else { return }

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
    // MARK: 좌표를 CLLocation으로 변환
    func changeToClLocation(latitude: Double?, longitude: Double?) -> CLLocation? {
        guard let latitude = latitude, let longitude = longitude else { return nil }
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    // MARK: - CLLocation을 주소로 변환
    static func changeToAddress(location: CLLocation?) -> String {
        var address: String = ""
        
        if let location = location {
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemarks, error in
                if error == nil {
                    guard let placemarks = placemarks,
                          let placemark = placemarks.last else { return }

                    address = (placemark.addressDictionary?["FormattedAddressLines"] as? [String])?.first ?? ""
                } else {
                    print("주소로 변환하지 못했습니다.")
                }
            })
        }
        
        return address
    }
    
    // MARK: - 주소로 화면 이동
    func moveFocusChange(location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.01)
        
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
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
            moveFocusChange(location: annotation.coordinate)
            
            if annotations.count >= 2 {
                let line = Line(coordinates: annotations.map { $0.coordinate })
                lines.append(line)
            }
        }
    }
    // MARK: - 사용자 위치로 포인터 이동
    func moveFocusOnUserLocation() {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        if !mapView.annotations.isEmpty && !placeList.isEmpty {
            print("place => \(placeList)")
            let annotation = mapView.annotations.filter { $0.title == placeList[0].placeName }
            if annotation.isEmpty == false {
                mapView.deselectAnnotation(annotation[0], animated: true)
                
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways else { return }
        locationManager.requestLocation()
        moveFocusOnUserLocation()
    }
}

extension LocationManager: MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        if !isChaging {
            DispatchQueue.main.async {
                self.isChaging = true
            }
        }
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location: CLLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        LocationManager.changeToAddress(location: location)
        
        DispatchQueue.main.async {
            self.isChaging = false
        }
    }
    // 라인 뷰 제공
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .red
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
}
