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
    @State private var isShowingMapView: Bool = false
    
    @Binding var searchAddress: String
    @FocusState private var isKeyboardUp: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                HStack {
                    Text("위치")
                        .font(.body02)
                    Spacer()
                    if isShowingAddress {
                        Text("\(locationManager.selectedAddress)")
                            .font(.body04)
                    }
                }
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
                                    .focused($isKeyboardUp)
                                }
                            }
                    }
                }
                if isShowingMapView == true {
                    MapViewCoordinater(locationManager: locationManager)
                        .frame(width: 329, height: 170)
                        .cornerRadius(12)
                }
                Spacer()
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
                        }
                }
                .onTapGesture {
                    isKeyboardUp = false
                }
                .offset(CGSize(width: geometry.size.width - 70, height: geometry.size.height / 3))
                
                Image(systemName: "mappin")
                    .resizable()
                    .position(CGPoint(x: geometry.size.width / 2, y: locationManager.isChaging ? (geometry.size.height / 2 - 5) : (geometry.size.height / 2)))
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 24, alignment: .center)
                    .foregroundStyle(Color.myPrimary)
            }
        }
        .frame(height: isShowingMapView ? 248 : 120)
    }
}

#Preview {
    AddPaymentMapView(locationManager: LocationManager(), searchAddress: .constant("cheonan"))
}
