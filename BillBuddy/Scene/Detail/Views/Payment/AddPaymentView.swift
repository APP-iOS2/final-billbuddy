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

    var body: some View {
        VStack {
            List {
                SubPaymentView(travelCalculation: $travelCalculation, expandDetails: $expandDetails, priceString: $priceString, selectedCategory: $selectedCategory, paymentDate: $paymentDate)
                    .onAppear {
                        paymentDate = travelCalculation.startDate.toDate()
                    }
                
                AddPaymentMemberView(newMembers: $newMembers, travelCalculation: $travelCalculation)
                
                Section {
                    HStack {
                        Text("위치")
                            .font(.custom("Pretendard-Bold", size: 14))
                        
                        Spacer()
                        // Payment.Address(address: "", latitude: 0, longitude: 0)
                    }
                    .padding(.leading, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                }
                // 위치
                AddPaymentMapView()
                    .frame(height: 500)
                
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
                Payment(type: selectedCategory ?? Payment.PaymentType.etc, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: locationManager.selectedAddress, latitude: locationManager.userLatitude, longitude: locationManager.userLongitude), participants: participants, paymentDate: paymentDate.timeIntervalSince1970)
                
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
