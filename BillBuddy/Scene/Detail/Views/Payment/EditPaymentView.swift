//
//  EditPaymentSheet.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/27.
//

import SwiftUI

struct EditPaymentView: View {
    @Environment(\.dismiss) private var dismiss
    
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
            ScrollView {
                SubPaymentView(travelCalculation: $travelCalculation, expandDetails: $expandDetails, priceString: $priceString, selectedCategory: $selectedCategory, paymentDate: $paymentDate)
                    .onAppear {
                        selectedCategory = payment.type
                        expandDetails = payment.content
                        priceString = String(payment.payment)
                        paymentDate = payment.paymentDate.toDate()
                    }
                
                EditPaymentMemberView(payment: $payment, travelCalculation: $travelCalculation)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                
                Section {
                    HStack {
                        EditPaymentMapView(locationManager: locationManager)
                            .frame(height: 500)
                    }
                    .padding(.leading, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                }
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
            }
            
            .background(Color.gray100)
            
            Button(action: {
                let newPayment = Payment(id: payment.id, type: selectedCategory ?? .etc, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: "", latitude: 0, longitude: 0), participants: payment.participants, paymentDate: paymentDate.timeIntervalSince1970)
                paymentStore.editPayment(payment: newPayment)
                dismiss()
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
            .background(Color.myPrimary)
            
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image("arrow_back")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
            
        })
        .onAppear {
            // TODO: 해당 payment만 fetch 되도록 수정
//            paymentStore.fetchAll()
        }
        
    }
        
}


