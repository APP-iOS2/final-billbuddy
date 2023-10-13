//
//  MainAddPaymentView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/11/23.
//

import SwiftUI


struct MainAddPaymentView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var userTravelStore: UserTravelStore
    
    @State var travelCalculation: TravelCalculation
    
    @State private var expandDetails: String = ""
    @State private var priceString: String = ""
    @State private var selectedCategory: Payment.PaymentType?
    @State private var paymentDate: Date = Date()
    @State private var newMembers: [TravelCalculation.Member] = []
    
    @State private var isShowingSelectTripSheet: Bool = false
    
    var divider: some View {
        Divider()
            .padding(.leading, 10)
            .padding(.trailing, 10)
    }
    
    var body: some View {
        VStack {
            List {
                Section{
                    HStack {
                        Text("여행")
                        Spacer()
                        Button(action: {
                            isShowingSelectTripSheet = true
                        }, label: {
                            Text(travelCalculation.travelTitle)
                        })
                    }
                }
                .sheet(isPresented: $isShowingSelectTripSheet, content: {
                    
                    SelectTripSheet(userTravelStore: userTravelStore, travelCalculation: $travelCalculation)
                        .presentationDetents([.fraction(0.4)])
                })
                
                SubPaymentView(travelCalculation: $travelCalculation, expandDetails: $expandDetails, priceString: $priceString, selectedCategory: $selectedCategory, paymentDate: $paymentDate)
                    .onAppear {
                        paymentDate = travelCalculation.startDate.toDate()
                    }
                
                Section {
                    HStack {
                        Text("위치")
                        Spacer()
                        // Payment.Address(address: "", latitude: 0, longitude: 0)
                    }
                }
                
                AddPaymentMemberView(newMembers: $newMembers, travelCalculation: $travelCalculation)
            }
            .onAppear {
                if let first = userTravelStore.travels.first {
                    travelCalculation = first
                }
            }
            
            
            Button(action: {
                var participants: [Payment.Participant] = []
                
                for m in newMembers {
                    participants.append(Payment.Participant(memberId: m.id, payment: m.payment))
                }
                
                let newPayment =
                Payment(type: selectedCategory ?? .etc, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: "", latitude: 0, longitude: 0), participants: participants, paymentDate: paymentDate.timeIntervalSince1970)
                userTravelStore.addPayment(travelCalculation: travelCalculation, payment: newPayment)
                presentationMode.wrappedValue.dismiss()
                
            }, label: {
                HStack {
                    Spacer()
                    Text("추가하기")
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
                    Image("arrow_back")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
            
        })
        .navigationBarBackButtonHidden()
        .navigationTitle(
            Text("지출 항목 추가")
                .font(.custom("Pretendard-Bold", size: 18))
        )
    }
}

//#Preview {
//    MainAddPaymentView()
//}
