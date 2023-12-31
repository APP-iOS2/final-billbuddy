//
//  PaymentManageView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/17/23.
//

import SwiftUI

struct PaymentManageView: View {
    
    enum Mode {
        case mainAdd
        case add
        case edit
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @State var mode: Mode
    @State var payment: Payment?
    @State var travelCalculation: TravelCalculation
    
    @StateObject var locationManager = LocationManager()
    @EnvironmentObject private var settlementExpensesStore: SettlementExpensesStore
    @EnvironmentObject private var tabBarVisivilyStore: TabBarVisivilyStore
    @EnvironmentObject private var paymentStore: PaymentStore
    @EnvironmentObject private var userTravelStore: UserTravelStore
    @EnvironmentObject private var notificationStore: NotificationStore
    
    @State private var expandDetails: String = ""
    @State private var priceString: String = ""
    @State private var searchAddress: String = ""
    @State private var selectedCategory: Payment.PaymentType?
    @State private var paymentDate: Date = Date.now
    @State private var isShowingSelectTripSheet: Bool = false
    @State private var isShowingNoTravelAlert: Bool = false
    @State private var navigationTitleString: String = "지출 내역 추가"
    @State private var isShowingAlert: Bool = false
    @State private var participants: [Payment.Participant] = []
    @State private var isShowingMemberSheet: Bool = false
    
    @FocusState private var focusedField: PaymentFocusField?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    if mode == .mainAdd {
                        // 메인에서 바로 지출 추가하기로 들어가면, travel을 선택해야함
                        selectTravelSection
                    }
                    fillInPaymentInfoViewSection
                    
                    mapViewSection
                }
            }
            .background(Color.gray100)
            
            underButton
        }
        .toolbar(tabBarVisivilyStore.visivility, for: .tabBar)
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
            ToolbarItem(placement: .principal) {
                Text(navigationTitleString)
                    .font(.title05)
            }
        })
        .onAppear {
            tabBarVisivilyStore.hideTabBar()
            if mode == .edit {
                navigationTitleString = "지출 내역 수정"
            }
            
            if mode == .mainAdd{
                isShowingSelectTripSheet = true
                if let first =  userTravelStore.travels.first {
                    travelCalculation = first
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

extension PaymentManageView {
    // MARK: SubView Section
    var selectTravelSection: some View {
        Group {
            HStack {
                Text("여행")
                    .font(.body02)
                
                Spacer()
                Button(action: {
                    isShowingSelectTripSheet = true
                }, label: {
                    
                    Text(travelCalculation.travelTitle)
                        .font(.body04)
                        .foregroundStyle(Color.gray600)
                    
                })
            }
            .padding(.leading, 16)
            .padding(.top, 16)
            .padding(.bottom, 16)
            .padding(.trailing, 16)
            
            .sheet(isPresented: $isShowingSelectTripSheet, content: {
                VStack {
                    ForEach(userTravelStore.travels) { travel in
                        HStack {
                            Button(action: {
                                travelCalculation = travel
                                paymentDate = travel.startDate.toDate()
                                isShowingSelectTripSheet = false
                            }, label: {
                                Text(travel.travelTitle)
                                    .font(.body01)
                            })
                            .buttonStyle(.plain)
                            .padding(.bottom, 32)
                            
                            Spacer()
                        }
                    }
                }
                .padding(.top, 48)
                .padding(.leading, 30)
                .presentationDetents([.fraction(0.4)])
            })
        }
        .onAppear {
            if userTravelStore.travels.isEmpty {
                isShowingNoTravelAlert = true
            }
            else {
                isShowingSelectTripSheet = true
            }
        }
        .alert(isPresented: $isShowingNoTravelAlert, content: {
            
            return Alert(title: Text(PaymentAlertText.noTravel),
                         dismissButton: .default(Text("확인"), action: { dismiss()}))
        })
        
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        }
        .padding(.top, 16)
        .padding(.leading, 16)
        .padding(.trailing, 16)
    }
    
    var fillInPaymentInfoViewSection: some View {
        Section {
            switch mode {
            case .add:
                FillInPaymentInfoView(travelCalculation: $travelCalculation, expandDetails: $expandDetails, priceString: $priceString, selectedCategory: $selectedCategory, paymentDate: $paymentDate, payment: .constant(nil), participants: $participants, isShowingMemberSheet: $isShowingMemberSheet, focusedField: $focusedField)
                    .onAppear {
                        paymentDate = travelCalculation.startDate.toDate()
                    }
            case .edit:
                FillInPaymentInfoView(mode: .edit, travelCalculation: $travelCalculation, expandDetails: $expandDetails, priceString: $priceString, selectedCategory: $selectedCategory, paymentDate: $paymentDate, payment: $payment, participants: $participants, isShowingMemberSheet: $isShowingMemberSheet, focusedField: $focusedField)
                    .onAppear {
                        if let payment = payment {
                            selectedCategory = payment.type
                            expandDetails = payment.content
                            priceString = String(payment.payment)
                            paymentDate = payment.paymentDate.toDate()
                        }
                    }
            case .mainAdd:
                FillInPaymentInfoView(travelCalculation: $travelCalculation, expandDetails: $expandDetails, priceString: $priceString, selectedCategory: $selectedCategory, paymentDate: $paymentDate, payment: .constant(nil), participants: $participants, isShowingMemberSheet: $isShowingMemberSheet, focusedField: $focusedField)
                    .onAppear {
                        paymentDate = travelCalculation.startDate.toDate()
                    }
            }
        }
    }
    
    var mapViewSection: some View {
        Section {
            AddPaymentMapView(locationManager: locationManager, searchAddress: $searchAddress)
                .onAppear {
                    if let p = payment {
                        searchAddress = p.address.address
                    }
                }
            Spacer()
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        }
        .padding(.leading, 16)
        .padding(.top, 16)
        .padding(.trailing, 16)
        .padding(.bottom, 38)
    }
    
    var underButton: some View {
        Button(action: {
            if mode == .mainAdd && travelCalculation.travelTitle.isEmpty {
                isShowingSelectTripSheet = true
            }
            else if selectedCategory == nil {
                focusedField = .type
            }
            else if expandDetails.isEmpty {
                focusedField = .content
            }
            else if priceString.isEmpty {
                focusedField = .price
            }
            
            isShowingAlert = true
            
        }, label: {
            switch(mode) {
            case .add:
                PaymentButtonView(scale: .big, text: "추가하기")
            case .mainAdd:
                PaymentButtonView(scale: .big, text: "추가하기")
            case .edit:
                PaymentButtonView(scale: .big, text: "수정하기")
            }
        })
        .alert(isPresented: $isShowingAlert, content: {
            if mode == .mainAdd && travelCalculation.travelTitle.isEmpty {
                return Alert(title: Text(PaymentAlertText.selectTravel))
            }
            else if selectedCategory == nil {
                return Alert(title: Text(PaymentAlertText.selectCategory))
            }
            else if expandDetails.isEmpty {
                focusedField = .content
                return Alert(title: Text(PaymentAlertText.typeContent))
            }
            else if priceString.isEmpty {
                focusedField = .price
                return Alert(title: Text(PaymentAlertText.price))
            }
            else if participants.isEmpty {
                focusedField = .none
                return Alert(title: Text(PaymentAlertText.selectMember), dismissButton: .default(Text("인원 추가하기"), action: {
                    hideKeyboard()
                    isShowingMemberSheet = true
                }))
            }
            else {
                switch(mode) {
                case .add:
                    return Alert(title: Text(PaymentAlertText.add), primaryButton: .cancel(Text("아니오")), secondaryButton: .default(Text("네"), action: {
                        addPayment()
                        dismiss()
                    }))
                case .mainAdd:
                    return Alert(title: Text(PaymentAlertText.add), primaryButton: .cancel(Text("아니오")), secondaryButton: .default(Text("네"), action: {
                        mainAddPayment()
                        dismiss()
                    }))
                case .edit:
                    return Alert(title: Text(PaymentAlertText.edit), primaryButton: .cancel(Text("아니오")), secondaryButton: .default(Text("네"), action: {
                        editPayment()
                        dismiss()
                    }))
                }
            }
        })
        .background(Color.myPrimary)
    }
}

extension PaymentManageView {
    // MARK: Function Section
    func addPayment() {
        let newPayment =
        Payment(type: selectedCategory ?? .etc, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: locationManager.selectedAddress, latitude: locationManager.selectedLatitude, longitude: locationManager.selectedLongitude), participants: participants, paymentDate: paymentDate.timeIntervalSince1970)
        
        Task {
            await paymentStore.addPayment(newPayment: newPayment)
            settlementExpensesStore.setSettlementExpenses(payments: paymentStore.payments, members: self.travelCalculation.members)
        }
        
        PushNotificationManager.sendPushNotification(toTravel: travelCalculation, title: "\(travelCalculation.travelTitle)여행방", body: "지출이 추가 되었습니다.", senderToken: "senderToken")
        notificationStore.sendNotification(members: travelCalculation.members, notification: UserNotification(type: .travel, content: "\(travelCalculation.travelTitle)여행방에서 확인하지 않은 지출", contentId: "\(URLSchemeBase.scheme.rawValue)://travel?travelId=\(travelCalculation.id)", addDate: Date(), isChecked: false))
    }
    
    func mainAddPayment() {
        let newPayment =
        Payment(type: selectedCategory ?? .etc, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: locationManager.selectedAddress, latitude: locationManager.selectedLatitude, longitude: locationManager.selectedLongitude), participants: participants, paymentDate: paymentDate.timeIntervalSince1970)
        userTravelStore.addPayment(travelCalculation: travelCalculation, payment: newPayment)
        
        PushNotificationManager.sendPushNotification(toTravel: travelCalculation, title: "\(travelCalculation.travelTitle)여행방", body: "지출이 추가 되었습니다.", senderToken: "senderToken")
        notificationStore.sendNotification(members: travelCalculation.members, notification: UserNotification(type: .travel, content: "\(travelCalculation.travelTitle)여행방에서 확인하지 않은 지출", contentId: "\(URLSchemeBase.scheme.rawValue)://travel?travelId=\(travelCalculation.id)", addDate: Date(), isChecked: false))
    }
    
    func editPayment() {
        if let payment = payment {
            let newPayment = Payment(id: payment.id, type: selectedCategory ?? .etc, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: locationManager.selectedAddress, latitude: locationManager.selectedLatitude, longitude: locationManager.selectedLongitude), participants: participants, paymentDate: paymentDate.timeIntervalSince1970)
            Task {
                await paymentStore.editPayment(payment: newPayment)
                settlementExpensesStore.setSettlementExpenses(payments: paymentStore.payments, members: self.travelCalculation.members)
            }
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
