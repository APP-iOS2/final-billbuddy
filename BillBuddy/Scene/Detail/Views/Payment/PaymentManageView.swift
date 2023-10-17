//
//  PaymentManageView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/17/23.
//

import SwiftUI

/*
// MainAddPaymentView
@ObservedObject var userTravelStore: UserTravelStore
@State var travelCalculation: TravelCalculation

// AddPaymentView
@Binding var travelCalculation: TravelCalculation
@ObservedObject var paymentStore: PaymentStore

// EditPaymentView
@State var payment: Payment
@Binding var travelCalculation: TravelCalculation
@ObservedObject var paymentStore: PaymentStore
 */

struct PaymentManageView: View {
    
    enum Mode {
        case mainAdd
        case add
        case edit
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @State var mode: Mode
    
    @State var payment: Payment?
    @Binding var travelCalculation: TravelCalculation
    
    @StateObject var locationManager = LocationManager()
    
    @EnvironmentObject var paymentStore: PaymentStore
    @EnvironmentObject var userTravelStore: UserTravelStore
    
    @State private var expandDetails: String = ""
    @State private var priceString: String = ""
    @State private var selectedCategory: Payment.PaymentType?
    @State private var paymentDate: Date = Date()
    @State private var members: [TravelCalculation.Member] = []
    @State private var isShowingSelectTripSheet: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                if mode == .mainAdd {
                    selectTravelSection
                }
                
                subPaymentViewSection
                
                mapViewSection
            }
            .background(Color.gray100)
            
            button
            
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
    }
    
    var selectTravelSection: some View {
        Group {
            HStack {
                Text("여행")
                    .font(.custom("Pretendard-Bold", size: 14))
                
                Spacer()
                Button(action: {
                    isShowingSelectTripSheet = true
                }, label: {
                    Text(travelCalculation.travelTitle)
                    Text("button")
                })
            }
            .padding(.leading, 16)
            .padding(.top, 16)
            .padding(.bottom, 16)
            .padding(.trailing, 16)
            
            .sheet(isPresented: $isShowingSelectTripSheet, content: {
                
                SelectTripSheet(userTravelStore: userTravelStore, travelCalculation: $travelCalculation)
                    .presentationDetents([.fraction(0.4)])
            })
        }
        
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        }
        .padding(.top, 16)
        .padding(.leading, 16)
        .padding(.trailing, 16)
    }
    
    var subPaymentViewSection: some View {
        switch(mode) {
        case .add:
            SubPaymentView(travelCalculation: $travelCalculation, expandDetails: $expandDetails, priceString: $priceString, selectedCategory: $selectedCategory, paymentDate: $paymentDate, members: $members, payment: .constant(nil))
                .onAppear {
                    paymentDate = travelCalculation.startDate.toDate()
                }
        case .edit:
            SubPaymentView(mode: .edit, travelCalculation: $travelCalculation, expandDetails: $expandDetails, priceString: $priceString, selectedCategory: $selectedCategory, paymentDate: $paymentDate, members: $members, payment: $payment)
                .onAppear {
                    if let payment = payment {
                        selectedCategory = payment.type
                        expandDetails = payment.content
                        priceString = String(payment.payment)
                        paymentDate = payment.paymentDate.toDate()
                    }
                }
        case .mainAdd:
            SubPaymentView(travelCalculation: $travelCalculation, expandDetails: $expandDetails, priceString: $priceString, selectedCategory: $selectedCategory, paymentDate: $paymentDate, members: $members, payment: .constant(nil))
                .onAppear {
                    paymentDate = travelCalculation.startDate.toDate()
                }
        }
    }
    
    var mapViewSection: some View {
        Section {
            switch(mode) {
            case .edit:
                HStack {
                    EditPaymentMapView(locationManager: locationManager)
                        .frame(height: 500)
                }
                .padding(.leading, 16)
                .padding(.top, 16)
                .padding(.bottom, 16)
            case .mainAdd:
                AddPaymentMapView()
                    .frame(height: 500)
                Spacer()
            case .add:
                AddPaymentMapView()
                    .frame(height: 500)
                Spacer()
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
    }
    
    func buttonText(text: String) -> Text {
        return Text(text)
            .font(.custom("Pretendard-Bold", size: 18))
            .foregroundColor(.white)
    }
    
    var buttonLabel: some View {
        HStack {
            Spacer()
            
            switch(mode) {
            case .add:
                buttonText(text: "추가하기")
            case .mainAdd:
                buttonText(text: "추가하기")
            case .edit:
                buttonText(text: "수정하기")
            }
            
            Spacer()
        }
        .padding(.top, 24)
        .padding(.bottom, 24)
    }
    
    var button: some View {
        Button(action: {
            switch(mode) {
            case .add:
                addPayment()
            case .mainAdd:
                mainAddPayment()
            case .edit:
                editPayment()
            }
            
        }, label: {
            buttonLabel
        })
        .background(Color.myPrimary)
    }
}

extension PaymentManageView {
    func addPayment() {
        var participants: [Payment.Participant] = []
        
        for m in members {
            participants.append(Payment.Participant(memberId: m.id, payment: m.payment))
        }
        
        let newPayment =
        Payment(type: selectedCategory ?? .etc, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: "", latitude: 0, longitude: 0), participants: participants, paymentDate: paymentDate.timeIntervalSince1970)
        
        //
        paymentStore.addPayment(newPayment: newPayment)
        dismiss()
    }
    
    func mainAddPayment() {
        var participants: [Payment.Participant] = []
        
        for m in members {
            participants.append(Payment.Participant(memberId: m.id, payment: m.payment))
        }
        
        let newPayment =
        Payment(type: selectedCategory ?? .etc, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: "", latitude: 0, longitude: 0), participants: participants, paymentDate: paymentDate.timeIntervalSince1970)
        userTravelStore.addPayment(travelCalculation: travelCalculation, payment: newPayment)
        dismiss()
    }
    
    func editPayment() {
        if let payment = payment {
            let newPayment = Payment(id: payment.id, type: selectedCategory ?? .etc, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: "", latitude: 0, longitude: 0), participants: payment.participants, paymentDate: paymentDate.timeIntervalSince1970)
            paymentStore.editPayment(payment: newPayment)
            dismiss()
        }
    }
}

//#Preview {
//    PaymentManageView(travelCalculation: <#Binding<TravelCalculation>#>, paymentStore: <#PaymentStore#>)
//}
