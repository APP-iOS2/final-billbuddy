//
//  AddPaymentMapView.swift
//  BillBuddy
//
//  Created by 이승준 on 10/11/23.
//

import SwiftUI

struct AddPaymentMapView: View {
    @ObservedObject var locationManager: LocationManager
    
    @State private var isShowingAddress: Bool = false
    
    @Binding var searchAddress: String
    @Binding var searchlatitude: Double
    @Binding var searchlongitude: Double
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("위치")
                        .font(.custom("Pretendard-Bold", size: 18))
                    Spacer()
                    if isShowingAddress {
                        Text("입력된 주소 : \(locationManager.selectedAddress)")
                    }
                }
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(uiColor: .systemGray6))
                        .frame(width: geometry.size.width * 4.6/5, height: 40)
                        .shadow(radius: 2, y: 1)
                        .overlay(alignment: .leading) {
                            HStack {
                                TextField("주소를 입력하세요", text: $searchAddress)
                                    .padding()
                                Button(action: {
                                    locationManager.searchAddress(searchAddress: searchAddress)
//                                    locationManager.selectedAddress = searchAddress
                                    isShowingAddress = true
                                    
                                }, label: {
                                    Image(systemName: "magnifyingglass")
                                        .font(.title2)
                                })
                                .padding()
                            }
                        }
                }
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
            
            Image("DBPin")
                .resizable()
                .position(CGPoint(x: geometry.size.width / 2 + 7, y: locationManager.isChaging ? (geometry.size.height / 2) : (geometry.size.height / 2 - 5)))
                .frame(width: 50, height: 50, alignment: .center)
        }
    }
}

#Preview {
    AddPaymentMapView(locationManager: LocationManager(), searchAddress: .constant("cheonan"), searchlatitude: .constant(0.0), searchlongitude: .constant(0.0))
}
