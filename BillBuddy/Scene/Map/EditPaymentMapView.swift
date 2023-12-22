//
//  EditPaymentMapView.swift
//  BillBuddy
//
//  Created by 이승준 on 10/12/23.
//

import SwiftUI

struct EditPaymentMapView: View {
    @ObservedObject var locationManager: LocationManager
    
    @Binding var searchAddress: String
    @State private var isShowingAddress: Bool = false
    @FocusState private var isKeyboardUp: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                HStack {
                    Text("위치")
                        .font(.body02)
                    Spacer()
                    if isShowingAddress {
                        Text("입력된 주소 : \(locationManager.selectedAddress)")
                    }
                }
                HStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: .systemGray6))
                        .frame(width: geometry.size.width * 4.6/5, height: 40)
                        .shadow(radius: 2, y: 1)
                        .overlay(alignment: .leading) {
                            HStack {
                                TextField("주소를 입력하세요", text: $searchAddress)
                                    .padding()
                                    .focused($isKeyboardUp)
                                Button(action: {
                                    locationManager.searchAddress(searchAddress: searchAddress)
                                    locationManager.selectedAddress = searchAddress
                                    isShowingAddress = true
                                    
                                }, label: {
                                    Image("my_location")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                })
                                .padding()
                            }
                        }
                }
                MapViewCoordinater(locationManager: locationManager)
                    .frame(width: 329, height: 170)
                    .cornerRadius(12)
            }
            .padding()
            .onTapGesture {
                isKeyboardUp = false
            }
            
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
            .offset(CGSize(width: geometry.size.width - 70, height: geometry.size.height / 2.3))
            
            Image("DBPin")
                .resizable()
                .position(CGPoint(x: geometry.size.width / 2 + 7, y: locationManager.isChaging ? (geometry.size.height / 1.5) : (geometry.size.height / 1.5 - 5)))
                .frame(width: 50, height: 50, alignment: .center)
        }
        .frame(height: 248)
    }
}

#Preview {
    EditPaymentMapView(locationManager: LocationManager(), searchAddress: .constant("cheonan"))
}
