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
    @State private var selectedCategory: Payment.PaymentType?
    @State private var paymentDate: Date = Date()

    var body: some View {
        VStack {
            
            List {
                SubPaymentView(travelCalculation: $travelCalculation, expandDetails: $expandDetails, priceString: $priceString, selectedCategory: $selectedCategory, paymentDate: $paymentDate)
                    .onAppear {
                        selectedCategory = payment.type
                        expandDetails = payment.content
                        priceString = String(payment.payment)
                        paymentDate = payment.paymentDate.toDate()
                    }
                
                EditPaymentMemberView(payment: $payment, travelCalculation: $travelCalculation)
                
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
        .onAppear {
            // TODO: 해당 payment만 fetch 되도록 수정
            paymentStore.fetchAll()
        }
        
    }
        
}


