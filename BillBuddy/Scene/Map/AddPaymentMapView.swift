//
//  AddPaymentMapView.swift
//  BillBuddy
//
//  Created by 이승준 on 10/11/23.
//

import SwiftUI

struct AddPaymentMapView: View {
    @StateObject var locationManager: LocationManager
    
    @State private var isShowingAddress: Bool = false
    @State private var isShowingMapView: Bool = false
    
    @Binding var searchAddress: String
//    @Binding var searchlatitude: Double
//    @Binding var searchlongitude: Double
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("위치")
                        .font(.custom("Pretendard-Bold", size: 14))
                    Spacer()
                    if isShowingAddress {
                        Text("\(locationManager.selectedAddress)")
                    }
                }
                Spacer()
                if isShowingMapView == false {
                    HStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(uiColor: .systemGray6))
                            .frame(width: geometry.size.width * 4.6/5, height: 40)
                            .overlay(alignment: .leading) {
                                HStack {
                                    TextField("주소 입력", text: $searchAddress)
                                        .padding()
                                    Button(action: {
                                        locationManager.searchAddress(searchAddress: searchAddress)
                                        isShowingAddress = true
                                        isShowingMapView = true
                                        
                                    }, label: {
                                        Image("my_location")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundStyle(Color.primary2)
                                    })
                                    .padding()
                                }
                            }
                    }
                }
                if isShowingMapView == true {
                    MapViewCoordinater(locationManager: locationManager)
                        .frame(width: 329, height: 170)
                        .cornerRadius(12)
                }
            }
            .padding()
            
            if isShowingMapView == true {
                Button {
                    locationManager.moveFocusOnUserLocation()
                } label: {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .shadow(radius: 2, y: 1)
                        .overlay {
                            Image("my_location")
                                .resizable()
                                .frame(width: 24, height: 24)
//                                .renderingMode(.template)
                                
                        }
                }
                .offset(CGSize(width: geometry.size.width - 70, height: geometry.size.height / 3))
                
                Image("DBPin")
                    .resizable()
                    .position(CGPoint(x: geometry.size.width / 2 + 7, y: locationManager.isChaging ? (geometry.size.height / 2) : (geometry.size.height / 2 - 5)))
                    .frame(width: 50, height: 50, alignment: .center)
            }
        }
        .frame(height: isShowingMapView ? 248 : 120)
    }
}

#Preview {
    AddPaymentMapView(locationManager: LocationManager(), searchAddress: .constant("cheonan"))
}
