//
//  MapSubView.swift
//  BillBuddy
//
//  Created by 이승준 on 10/12/23.
//

import SwiftUI

struct MapSubView: View {
    
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    MapViewCoordinater(locationManager: locationManager)
                }
                .padding()
                
                Button {
                    locationManager.moveFocusOnUserLocation()
                } label: {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 45, height: 45)
                        .shadow(radius: 2, y: 1)
                        .overlay {
                            Image(systemName: "scope")
                                .renderingMode(.template)
                        }
                }
                .offset(CGSize(width: geometry.size.width - 70, height: geometry.size.height - 70))
                
            }
        }
    }
}

#Preview {
    MapSubView()
}
