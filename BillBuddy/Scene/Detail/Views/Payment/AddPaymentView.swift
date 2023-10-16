//
//  AddPaymentSheetView.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/25.
//

import SwiftUI

struct AddPaymentView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var travelCalculation: TravelCalculation
    @ObservedObject var paymentStore: PaymentStore
    @StateObject var locationManager = LocationManager()
    
    @State private var expandDetails: String = ""
    @State private var priceString: String = ""
    @State private var selectedCategory: Payment.PaymentType?
    @State private var paymentDate: Date = Date()
    @State private var newMembers: [TravelCalculation.Member] = []
    @State private var searchAddress: String = ""
    @State private var searchlatitude: Double = 0.0
    @State private var searchlongitude: Double = 0.0
    
    var body: some View {
        VStack {
            List {
                SubPaymentView(travelCalculation: $travelCalculation, expandDetails: $expandDetails, priceString: $priceString, selectedCategory: $selectedCategory, paymentDate: $paymentDate)
                    .onAppear {
                        paymentDate = travelCalculation.startDate.toDate()
                    }
                
                AddPaymentMemberView(newMembers: $newMembers, travelCalculation: $travelCalculation)
                
                Section {
                    // 위치
                    AddPaymentMapView(locationManager: locationManager, searchAddress: $searchAddress, searchlatitude: $searchlatitude, searchlongitude: $searchlongitude)
                        .frame(height: 500)
                        
                    Spacer()
                        // Payment.Address(address: "", latitude: 0, longitude: 0)
                }
                
            }
            .onAppear{
                paymentDate = travelCalculation.startDate.toDate()
            }
            
            Button(action: {
                var participants: [Payment.Participant] = []
                
                for m in newMembers {
                    participants.append(Payment.Participant(memberId: m.id, payment: m.payment))
                }
                
                let newPayment =
                Payment(type: selectedCategory ?? .etc, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: locationManager.selectedAddress, latitude: locationManager.userLatitude, longitude: locationManager.userLongitude), participants: participants, paymentDate: paymentDate.timeIntervalSince1970)
                paymentStore.addPayment(newPayment: newPayment)
                presentationMode.wrappedValue.dismiss()
                
            }, label: {
                HStack {
                    Spacer()
                    Text("추가하기")
                        .font(.custom("Pretendard-Bold", size: 18))
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.bottom, 24)
            })
            .background(Color.primary)
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("arrow_back")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
            
        })
    }
}

//#Preview {
//    AddPaymentView(paymentStore: PaymentStore(travelCalculationId: "4eB3HvBvH6jXYDLu9irl"), travelCalculation: trav)
//
//}
