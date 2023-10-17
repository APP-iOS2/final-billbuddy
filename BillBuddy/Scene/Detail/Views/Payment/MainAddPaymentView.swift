//
//  MainAddPaymentView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/11/23.
//

import SwiftUI


struct MainAddPaymentView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var userTravelStore: UserTravelStore
    
    @State var travelCalculation: TravelCalculation
    
    @State private var expandDetails: String = ""
    @State private var priceString: String = ""
    @State private var selectedCategory: Payment.PaymentType?
    @State private var paymentDate: Date = Date()
    @State private var newMembers: [TravelCalculation.Member] = []
    
    @State private var isShowingSelectTripSheet: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                selectTravelSection
                
                SubPaymentView(travelCalculation: $travelCalculation, expandDetails: $expandDetails, priceString: $priceString, selectedCategory: $selectedCategory, paymentDate: $paymentDate, members: $newMembers, payment: .constant(nil))
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
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
            }
            .background(Color.gray100)
            .onAppear {
                if let first = userTravelStore.travels.first {
                    travelCalculation = first
                }
            }
            
            Button(action: {
                addPaymentButton()
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
                    dismiss()
                }, label: {
                    Image("arrow_back")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
            
        })
        .navigationBarBackButtonHidden()
        .navigationTitle(Text("지출 항목 추가"))
        .navigationBarTitleDisplayMode(.inline)
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
}

extension MainAddPaymentView {
    func addPaymentButton() {
        var participants: [Payment.Participant] = []
        
        for m in newMembers {
            participants.append(Payment.Participant(memberId: m.id, payment: m.payment))
        }
        
        let newPayment =
        Payment(type: selectedCategory ?? .etc, content: expandDetails, payment: Int(priceString) ?? 0, address: Payment.Address(address: "", latitude: 0, longitude: 0), participants: participants, paymentDate: paymentDate.timeIntervalSince1970)
        userTravelStore.addPayment(travelCalculation: travelCalculation, payment: newPayment)
        dismiss()
    }
}

//#Preview {
//    MainAddPaymentView()
//}
