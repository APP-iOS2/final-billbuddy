//
//  MapView.swift
//  BillBuddy
//
//

import SwiftUI

struct MapView: View {
    @StateObject var locationManager = LocationManager()
    
    @State private var searchText: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            MapViewCoordinater(locationManager: locationManager)
            VStack {
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: geometry.size.width, height: 40)
                        .shadow(radius: 2, y: 1)
                        .overlay(alignment: .leading) {
                            HStack {
                                TextField("주소를 입력하세요", text: $searchText)
                                    .padding()
                                Button(action: {
                                    locationManager.searchAddress(searchText: searchText)
                                }, label: {
                                    Text("추가")
                                })
                                .padding()
                            }
                        }
                }
            }
            Image("DBPin")
                .resizable()
                .position(CGPoint(x: geometry.size.width / 2 + 7, y: locationManager.isChaging ? (geometry.size.height / 2 - 25) : (geometry.size.height / 2 - 20)))
                .frame(width: 50, height: 50, alignment: .center)
        }
//        .onAppear {
//            locationManager.fetchAnotations()
//        }
    }
}

#Preview {
    MapView()
}
