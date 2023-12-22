//
//  Line.swift
//  BillBuddy
//
//  Created by 이승준 on 2023/09/27.
//

import Foundation
import MapKit

struct Line {
    var coordinates: [CLLocationCoordinate2D]
    
    var polyline: MKPolyline {
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
}
