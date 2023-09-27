//
//  MapView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct MapView: View {
    @StateObject var locationManager = LocationManager()
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("주소를 입력하세요", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    locationManager.searchAddress(searchText: searchText)
                }, label: {
                    Text("추가")
                })
                .padding()
            }
            MapViewCoordinater(locationManager: locationManager)
        }
    }
}

#Preview {
    MapView()
}
