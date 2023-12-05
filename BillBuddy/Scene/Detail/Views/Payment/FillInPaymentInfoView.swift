//
//  SubPaymentView.swift
//  BillBuddy
//
//  Created by 김유진 on 9/29/23.
//

import SwiftUI

enum Mode {
    case add
    case edit
}

struct FillInPaymentInfoView: View {
    
    @State var mode: Mode = .add
    
    @Binding var travelCalculation: TravelCalculation
    @Binding var expandDetails: String
    @Binding var priceString: String
    @Binding var selectedCategory: Payment.PaymentType?
    @Binding var paymentDate: Date
    @Binding var payment: Payment?
    @Binding var participants: [Payment.Participant]
    
    var focusedField: FocusState<PaymentFocusField?>.Binding
    
    @State private var isShowingDatePicker: Bool = false
    @State private var isShowingTimePicker: Bool = false
    @State private var paymentType: Int = 0 // 0: 1/n, 1: 개별
    @State private var selectedMember: TravelCalculation.Member = TravelCalculation.Member(name: "", advancePayment: 0, payment: 0)
    @State private var members: [TravelCalculation.Member] = []
    

    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                datePickerSection
                typePickerSection
                contentSection
                priceSection
                PaymentMemberManagementView(mode: mode, priceString: $priceString, travelCalculation: $travelCalculation, members: $members, payment: $payment, selectedMember: $selectedMember, participants: $participants)
            }
            .onTapGesture {
                hideKeyboard()
                isShowingDatePicker = false
                isShowingTimePicker = false
            }
            
            
            if isShowingDatePicker {
                DatePicker(selection: $paymentDate, in: travelCalculation.startDate.toDate()...travelCalculation.endDate.toDate(), displayedComponents: [.date], label: {
                    Text("날짜")
                        .font(.body02)
                })
                .labelsHidden()
                .datePickerStyle(.graphical)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                }
                .frame(width: 361, height: 400)
                .offset(y: 20)
            }
            
            
            if isShowingTimePicker {
                DatePicker(selection: $paymentDate, in: travelCalculation.startDate.toDate()...travelCalculation.endDate.toDate(), displayedComponents: [.hourAndMinute], label: {
                    Text("날짜")
                        .font(.body02)
                })
                .labelsHidden()
                .datePickerStyle(.wheel)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                }
                .frame(width: 198, height: 213)
                .offset(x: 20, y: -40)
            }
        }
    }
    
    var datePickerSection: some View {
        HStack(spacing: 4) {
            Text("날짜")
                .font(.body02)
                .padding(.leading, 16)
                .padding(.top, 16)
                .padding(.bottom, 20)
            
            Spacer()
            
            Button {
                isShowingDatePicker.toggle()
                if isShowingTimePicker {
                    isShowingTimePicker.toggle()
                }
            } label: {
                Text(paymentDate.datePickerDateFormat)
                    .font(.body04)
                    .padding(.leading, 11)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    .padding(.trailing, 11)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.lightBlue100)
                    }
                    .foregroundStyle(isShowingDatePicker ? Color.myPrimary : Color.gray600)
            }
            
            
            Button {
                isShowingTimePicker.toggle()
                if isShowingDatePicker {
                    isShowingDatePicker.toggle()
                }
            } label: {
                Text(paymentDate.datePickerTimeFormat)
                    .font(.body04)
                    .padding(.leading, 11)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    .padding(.trailing, 11)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.lightBlue100)
                    }
                    .foregroundStyle(isShowingTimePicker ? Color.myPrimary : Color.gray600)
            }
            .padding(.trailing, 16)
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        }
        .padding(.leading, 16)
        .padding(.top, 16)
        .padding(.trailing, 16)
        
    }
    var typePickerSection: some View {
        VStack {
            
            HStack{
                Text("분류")
                    .font(.body02)
                Spacer()
            }
            .padding(.leading, 16)
            .padding(.top, 16)
            .padding(.bottom, 20)
            
            HStack {
                Spacer()
                CategorySelectView(mode: .category, selectedCategory: $selectedCategory)
                Spacer()
            }
            .padding(.bottom, 30)
            .listRowSeparator(.hidden)
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
        
    }
    var contentSection: some View {
        Section {
            
            HStack {
                Text("내용")
                    .font(.body02)
                TextField("내용을 입력해주세요", text: $expandDetails)
                    .multilineTextAlignment(.trailing)
                    .font(.body04)
                    .focused(focusedField, equals: .content)
            }
            .padding(.leading, 16)
            .padding(.top, 16)
            .padding(.bottom, 16)
            .padding(.trailing, 16)
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
    }
    
    var priceSection: some View {
        Section {
            
            HStack {
                Text("결제금액")
                    .font(.body02)
                Spacer()
                
                
                TextField("결제금액을 입력해주세요", text: $priceString)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .font(.body04)
                    .focused(focusedField, equals: .price)
                    .onTapGesture {
                        priceString = ""
                    }
            }
            .padding(.leading, 16)
            .padding(.top, 16)
            .padding(.bottom, 16)
            .padding(.trailing, 16)
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
    }
}
