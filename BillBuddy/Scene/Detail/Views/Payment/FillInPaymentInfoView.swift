//
//  SubPaymentView.swift
//  BillBuddy
//
//  Created by 김유진 on 9/29/23.
//

import SwiftUI

struct FillInPaymentInfoView: View {
    
    enum Mode {
        case add
        case edit
    }
    
    @State var mode: Mode = .add
    
    @Binding var travelCalculation: TravelCalculation
    @Binding var expandDetails: String
    @Binding var priceString: String
    @Binding var selectedCategory: Payment.PaymentType?
    @Binding var paymentDate: Date
    @Binding var members: [TravelCalculation.Member]
    @Binding var payment: Payment?
    
    var focusedField: FocusState<PaymentFocusField?>.Binding
    
    @State private var isShowingMemberSheet: Bool = false
    @State private var isShowingDatePicker: Bool = false
    @State private var isShowingDescription: Bool = false
    @State private var isShowingTimePicker: Bool = false
    @State private var isShowingPersonalMemberSheet: Bool = false
    @State private var isShowingDatePickerSheet: Bool = false
    @State private var paidButton: Bool = false
    @State private var personalButton: Bool = false
    @State private var tempMembers: [TravelCalculation.Member] = []
    @State private var paymentType: Int = 0 // 0: 1/n, 1: 개별
    @State private var selectedMember: TravelCalculation.Member = TravelCalculation.Member(name: "", advancePayment: 0, payment: 0)
    
    @State private var personalPriceString: String = ""
    @State private var personalContent: String = ""
    
    private var expectPrice: Int {
        let price: Int = Int(priceString) ?? 0
        let count: Int = members.count
        
        if members.isEmpty {
            return 0
        }
        else {
            let result = price / count
            return result
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            datePickerSection
            
            if isShowingDatePicker {
                DatePicker(selection: $paymentDate, in: travelCalculation.startDate.toDate()...travelCalculation.endDate.toDate(), displayedComponents: [.date], label: {
                    Text("날짜")
                        .font(.body02)
                })
                .labelsHidden()
                .datePickerStyle(.wheel)
                .onTapGesture {
                    print("DatePicker tapped")
                }
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                }
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
            }
            
            typePickerSection
            contentSection
            priceSection
            memberSelectSection
        }
        .onTapGesture {
            hideKeyboard()
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
    var memberSection: some View {
        HStack {
            Text("인원")
                .font(.body02)
                .padding(.top, 16)
                .padding(.leading, 16)
                .padding(.bottom, 17)
            Spacer()
            Button(action: {
                hideKeyboard() 
                isShowingMemberSheet = true
            }, label: {
                HStack (spacing: 0) {
                    if members.isEmpty {
                        Text("추가하기")
                            .font(.body04)
                            .foregroundStyle(Color.gray600)
                        
                        Image("chevron_right")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.gray600)
                    }
                    else if members.count == travelCalculation.members.count {
                        Text("모든 인원")
                            .font(.body04)
                            .foregroundStyle(Color.gray600)
                        
                        Image("chevron_right")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.gray600)
                        
                    }
                    else {
                        Text("수정하기")
                            .font(.body04)
                            .foregroundStyle(Color.gray600)
                        
                        Image("chevron_right")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.gray600)
                    }
                    
                }
                .padding(.top, 14)
                .padding(.trailing, 16)
                .padding(.bottom, 15)
            })
            
        }
    }
    var memberSheet: some View {
        VStack(spacing: 0, content: {
            HStack {
                Spacer()
                
                Button(action: {
                    tempMembers = travelCalculation.members
                }, label: {
                    Text("전체 선택")
                })
                .font(.body03)
                .foregroundStyle(Color.myPrimary)
                
                Text("/")
                
                Button(action: {
                    tempMembers = []
                }, label: {
                    Text("전체 해제")
                })
                .font(.body03)
                .foregroundStyle(Color.myPrimary)
            }
            .padding(.trailing, 32)
            .padding(.top, 32)
            
            ScrollView {
                ForEach(travelCalculation.members) { member in
                    HStack {
                        Text(member.name)
                            .font(.body03)
                            .foregroundStyle(Color.black)
                        
                        Spacer()
                        
                        if tempMembers.firstIndex(where: { m in
                            m.name == member.name
                        }) != nil {
                            Image(.checked)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        else {
                            Image(.noneChecked)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding(.leading, 32)
                    .padding(.trailing, 46)
                    .padding(.top, 36)
                    .onTapGesture {
                        // TODO: firstIndex로 두번이나 찾으면 메모리 너무 많이 먹는거 아닌가
                        // 각각에 대해서 배열로 만들수도 없고 이걸 어뚜케 해야하지? 나중에 Refactoring 고민해보기!
                        if let existMember = tempMembers.firstIndex(where: { m in
                            m.name == member.name
                        }) {
                            tempMembers.remove(at: existMember)
                        }
                        else {
                            tempMembers.append(member)
                        }
                    }
                }
                .onAppear {
                    tempMembers = members
                }
                .presentationDetents([.fraction(0.45)])
            }
            
            .padding(.top, 8)
            .padding(.bottom, 36)
        })
        
        
    }
    var addPaymentMember: some View {
        VStack(spacing: 0) {
            memberSection
                .sheet(isPresented: $isShowingMemberSheet, content: {
                    addPaymentMemberSheet
                })
            
            memberListSection
        }
    }
    var addPaymentMemberSheet: some View {
        VStack {
            memberSheet
            
            Button(action: {
                members = tempMembers
                isShowingMemberSheet = false
            }, label: {
                HStack {
                    Spacer()
                    Text("인원 추가")
                        .font(.body02)
                        .padding(.top, 16)
                        .padding(.bottom, 16)
                    Spacer()
                }
            })
            .buttonStyle(.borderedProminent)
            .padding(.leading, 31)
            .padding(.trailing, 31)
            .frame(height: 52)
        }
    }
    var editPaymentMember: some View {
        VStack(spacing: 0) {
            
            memberSection
                .sheet(isPresented: $isShowingMemberSheet, content: {
                    editPaymentMemberSheet
                })
            memberListSection
        }
        .onAppear {
            if let payment = payment {
                for participant in payment.participants {
                    if let existMember = travelCalculation.members.firstIndex(where: { m in
                        m.id == participant.memberId
                    }) {
                        if let _ = members.firstIndex(of: travelCalculation.members[existMember]) {
                            continue
                        }
                        members.append(travelCalculation.members[existMember])
                    }
                }
            }
        }
    }
    var editPaymentMemberSheet: some View {
        VStack {
            memberSheet
            
            Button(action: {
                isShowingMemberSheet = false
                var participants: [Payment.Participant] = []
                
                for m in tempMembers {
                    participants.append(Payment.Participant(memberId: m.id , payment: m.payment))
                }
                payment?.participants = participants
                
                members = tempMembers
            }, label: {
                HStack {
                    Spacer()
                    Text("인원 수정")
                        .font(.body02)
                        .padding(.top, 16)
                        .padding(.bottom, 16)
                    Spacer()
                }
            })
            .buttonStyle(.borderedProminent)
            .padding(.leading, 31)
            .padding(.trailing, 31)
            .frame(height: 52)
        }
    }
    var memberListSection: some View {
        ForEach(members) { member in
            Button(action: {
                selectedMember = member
                isShowingPersonalMemberSheet = true
            }, label: {
                HStack(spacing: 2) {
                    Text(member.name)
                        .font(.body04)
                        .padding(.leading, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 12)
                    Spacer()
                    Text("₩\(expectPrice)")
                        .font(.body04)
                        .foregroundStyle(Color.gray600)
                    Image("chevron_right")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.gray600)
                        .padding(.trailing, 10)
                }
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray050)
                }
            })
            .buttonStyle(.plain)
            .padding(.leading, 16)
            .padding(.trailing, 10)
            .padding(.bottom, 8)
            .sheet(isPresented: $isShowingPersonalMemberSheet, onDismiss: {
                paidButton = false
                personalButton = false
            }) {
                ZStack {
                    addPersonalPriceSection
                    if isShowingDescription {
                        descriptionOfPrice
                            .frame(width: 301, height: 226)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                            }
                            .shadow(radius: 6)
                            .offset(y: -10)
                    }
                }
                    .presentationDetents([.fraction(0.85)])
            }
        }
    }
    var descriptionOfPrice: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HStack(content: {
                Spacer()
                Button(action: {
                    isShowingDescription = false
                }, label: {
                    Image(.close)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 12)
                        .padding(.top, 12)
                    
                })
            })
            .padding(.bottom, 17)
            
            VStack(alignment: .leading, spacing: 0, content: {
                Text("먼저 지불한 금액")
                    .foregroundColor(Color.myPrimary)
                    .font(.body04)
                    + Text("은 전체 결제 금액에서 개인이 먼저 지불했던 금액이에요\n")
                    .font(.body04)
                
                Text("개인 사용 금액")
                    .foregroundColor(Color.myPrimary)
                    .font(.body04)
                    + Text("은 해당 인원의 금액을 따로 책정한 금액이에요\n")
                    .font(.body04)
                
                
                Text("입력하면 정산할 때 감안해서 계산해드려요")
                    .font(.body04)
                    
            })
            .frame(width: 253)
            .padding(.leading, 24)
            .padding(.trailing, 24)
            .padding(.bottom, 33)
        })
    }
    var memberSelectSection: some View {
        Section {
            switch(mode) {
            case .add:
                addPaymentMember
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
            case .edit:
                editPaymentMember
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
            }
        }
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
        
    var addPersonalPriceSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("개인 항목 추가")
                .font(.title04)
                .padding(.bottom, 10)
            
            Text("일행 개인의 상세 지출을 입력해요")
                .font(.body01)
                .padding(.bottom, 30)
            
            Text("\(selectedMember.name)")
                .font(.body01)
                .padding(.bottom, 12)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("분류")
                        .font(.body02)
                    Button(action: {
                        isShowingDescription = true
                    }, label: {
                        Image(.info)
                            .renderingMode(.template)
                            .foregroundStyle(Color.positive)
                    })
                    
                    
                    Spacer()
                    Button {
                        paidButton.toggle()
                        if personalButton {
                            personalButton.toggle()
                        }
                    } label: {
                        Text("먼저 지불한 금액")
                            .font(.body02)
                            .padding(.top, 8)
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                            .padding(.bottom, 8)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(paidButton ? Color.myPrimary : Color.gray200, lineWidth: 1)
                            )
                    }
                    .foregroundStyle(paidButton ? Color.myPrimary : Color.gray200)
                    .padding(.trailing, 8)
                    
                    Button {
                        personalButton.toggle()
                        if paidButton {
                            paidButton.toggle()
                        }
                    } label: {
                        Text("개인 사용 금액")
                            .font(.body02)
                            .padding(.top, 8)
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                            .padding(.bottom, 8)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(personalButton ? Color.myPrimary : Color.gray200, lineWidth: 1)
                            )
                    }
                    .foregroundStyle(personalButton ? Color.myPrimary : Color.gray200)
                }
                .padding(.bottom, 26)
                
                HStack {
                    Text("금액")
                        .font(.body03)
                    
                    Spacer()
                    
                    TextField("금액을 입력해주세요", text: $personalPriceString)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .font(.body04)
                        .onTapGesture {
                            personalPriceString = ""
                        }
                        .padding(.trailing, 14)
                }
                
                Divider()
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                HStack {
                    Text("메모사항")
                        .font(.body03)
                    
                    Spacer()
                    
                    TextField("내용을 입력해주세요", text: $personalContent)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .font(.body04)
                        .onTapGesture {
                            personalContent = ""
                        }
                        .padding(.trailing, 14)
                }
            }
            .padding(.top, 16)
            .padding(.leading, 15)
            .padding(.trailing, 14)
            .padding(.bottom, 16)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray050)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray100, lineWidth: 1)
                    )
            }
            .padding(.bottom, 12)
            
            
            
            HStack {
                Text("정산 예정 금액")
                    .font(.body01)
                    .padding(.top, 15)
                    .padding(.leading, 16)
                    .padding(.bottom, 14)
                Spacer()
                Text("₩25,000")
                    .font(.body01)
                    .padding(.top, 16)
                    .padding(.trailing, 16)
                    .padding(.bottom, 13)
            }
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray050)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray100, lineWidth: 1)
                    )
            }
            Spacer()
        }
        .padding(.leading, 20)
        .padding(.top, 39)
        .padding(.trailing, 16)
        .onTapGesture {
            hideKeyboard()
        }
    }
        
}

