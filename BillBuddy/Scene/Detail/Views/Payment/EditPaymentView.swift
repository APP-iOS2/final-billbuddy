//
//  EditPaymentSheet.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/27.
//

import SwiftUI

struct EditPaymentView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var payment: Payment
    
    @Binding var travelCalculation: TravelCalculation
    @ObservedObject var paymentStore: PaymentStore
    @StateObject var locationManager = LocationManager()
    
    @State private var expandDetails: String = ""
    @State private var priceString: String = ""
    @State private var headCountString: String = ""
    @State private var selectedCategory: Payment.PaymentType?
    @State private var category: String = "교통/숙박/관광/식비/기타"
    @State private var paymentDate: Date = Date()

    var body: some View {
        VStack {
            
            List {
                SubPaymentView(travelCalculation: $travelCalculation, expandDetails: $expandDetails, priceString: $priceString, headCountString: $headCountString, selectedCategory: $selectedCategory, category: $category, paymentDate: $paymentDate)
                    .onAppear {
                        category = payment.type.rawValue
                        selectedCategory = payment.type
                        expandDetails = payment.content
                        priceString = String(payment.payment)
                        paymentDate = payment.paymentDate.toDate()
                    }
                
                Section {
                    Text("위치")
                    
                    Text(payment.address.address)
                }
                
                EditPaymentMemberView(payment: $payment, travelCalculation: $travelCalculation)
                
                EditPaymentMapView(locationManager: locationManager)
                    .frame(height: 500)
            }
            
            Button(action: {
                let newPayment = Payment(id: payment.id, type: selectedCategory ?? .etc, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: locationManager.selectedAddress, latitude: locationManager.userLatitude, longitude: locationManager.userLongitude), participants: payment.participants, paymentDate: paymentDate.timeIntervalSince1970)
                paymentStore.editPayment(payment: newPayment)
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Spacer()
                    Text("수정하기")
                        .bold()
                    Spacer()
                }
                .padding()
            })
            .buttonStyle(.borderedProminent)
            .padding()
            
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                })
            }
            
        })
        .onAppear {
            paymentStore.fetchAll()
        }
        
    }
        
}


