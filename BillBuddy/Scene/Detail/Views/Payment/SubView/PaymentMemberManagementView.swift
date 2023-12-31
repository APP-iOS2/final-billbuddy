//
//  PaymentMemberManagementView.swift
//  BillBuddy
//
//  Created by 김유진 on 12/5/23.
//

import SwiftUI

struct PaymentMemberManagementView: View {
    @State var mode: PaymentCreateMode = .add
    
    @Binding var priceString: String
    @Binding var travelCalculation: TravelCalculation
    @Binding var members: [TravelCalculation.Member]
    @Binding var payment: Payment?
    @Binding var selectedMember: TravelCalculation.Member
    @Binding var participants: [Payment.Participant]
    @Binding var isShowingMemberSheet: Bool
    
    @State private var isShowingDescription: Bool = false
    @State private var isShowingPersonalMemberSheet: Bool = false
    @State private var paidButton: Bool = false
    @State private var personalButton: Bool = false
    @State private var tempMembers: [TravelCalculation.Member] = []
    
    @State private var advanceAmountString: String = ""
    @State private var seperateAmountString: String = ""
    @State private var personalMemo: String = ""
    @State private var seperate: [Int] = [0, 0]
    
    var body: some View {
        Section {
            VStack(spacing: 0) {
                memberSection
                    .sheet(isPresented: $isShowingMemberSheet, content: {
                        memberSheet
                    })
                
                participantsListSection
            }
            .onAppear {
                if mode == .edit {
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
                        participants = payment.participants
                        howManySeperate()
                    }
                }
            }
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
                    }
                    else if members.count == travelCalculation.members.count {
                        Text("모든 인원")
                            .font(.body04)
                            .foregroundStyle(Color.gray600)
                    }
                    else {
                        Text("수정하기")
                            .font(.body04)
                            .foregroundStyle(Color.gray600)
                    }
                    
                    Image("chevron_right")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.gray600)
                    
                }
                .padding(.top, 14)
                .padding(.trailing, 16)
                .padding(.bottom, 15)
            })
            
        }
    }
    
    var memberSheet: some View {
        VStack {
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
                                m.id == member.id
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
            })
            
            
            Button {
                if mode == .add {
                    addButton()
                }
                else if mode == .edit {
                    editButton()
                }
            } label: {
                if mode == .add {
                    Text("인원 추가")
                        .font(Font.body02)
                }
                else if mode == .edit {
                    Text("인원 수정")
                        .font(Font.body02)
                }
            }
            .frame(width: 332, height: 52)
            .background(Color.myPrimary)
            .cornerRadius(12)
            .foregroundColor(.white)
            .padding(.bottom, 54)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    var participantsListSection: some View {
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
                    
                    if let idx = participants.firstIndex(where: { p in
                        p.memberId == member.id
                    }) {
                        Text("₩\(getPersonalPrice(idx: idx))")
                            .font(.body04)
                            .foregroundStyle(Color.gray600)
                    }
                    else {
                        Text("₩0")
                            .font(.body04)
                            .foregroundStyle(Color.gray600)
                    }
                    
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
                    personalPriceView
                        .onAppear(perform: {
                            if let idx = participants.firstIndex(where: { p in
                                p.memberId == selectedMember.id
                            }) {
                                advanceAmountString = String(participants[idx].advanceAmount)
                                seperateAmountString = String(participants[idx].seperateAmount)
                                personalMemo = participants[idx].memo
                            }
                        })
                    if isShowingDescription {
                        descriptionOfPrice
                            .frame(width: 301, height: 226)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .shadow(radius: 6)
                            }
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
    
    var personalPriceView: some View {
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
                        Image(systemName: "info.circle")
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
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
                    
                    if paidButton {
                        TextField("금액을 입력해주세요", text: $advanceAmountString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .font(.body04)
                            .padding(.trailing, 14)
                            .onTapGesture {
                                advanceAmountString = ""
                            }
                    }
                    else if personalButton {
                        TextField("금액을 입력해주세요", text: $seperateAmountString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .font(.body04)
                            .padding(.trailing, 14)
                            .onTapGesture {
                                seperateAmountString = ""
                            }
                    }
                    else {
                        Text("분류를 먼저 선택해주세요")
                            .font(.body04)
                            .foregroundColor(Color.gray500)
                            .padding(.trailing, 14)
                    }
                    
                }
                
                Divider()
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                HStack {
                    Text("메모사항")
                        .font(.body03)
                    
                    Spacer()
                    
                    TextField("내용을 입력해주세요", text: $personalMemo)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .font(.body04)
                        .onTapGesture {
                            personalMemo = ""
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
                Text("₩\((Int(seperateAmountString) ?? 0) - (Int(advanceAmountString) ?? 0))")
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
            Button {
                personalPrice()
            } label: {
                HStack {
                    Spacer()
                    Text("확인")
                        .foregroundColor(Color.white)
                        .font(.body02)
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.bottom, 16)
            }
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.myPrimary)
            }
            .padding(.leading, 11)
            .padding(.trailing, 15)
            .padding(.bottom, 80)

        }
        .padding(.leading, 20)
        .padding(.top, 39)
        .padding(.trailing, 16)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

extension PaymentMemberManagementView {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func addButton() {
        participants = []
        for member in tempMembers {
            participants.append(Payment.Participant(memberId: member.id, advanceAmount: 0, seperateAmount: 0, memo: ""))
        }
        members = tempMembers
        isShowingMemberSheet = false
    }
    
    func editButton() {
        isShowingMemberSheet = false
        
        var tempParticipants: [Payment.Participant] = []
        for m in tempMembers {
            if let participant = participants.first(where: { p in
                p.memberId == m.id
            }) {
                tempParticipants.append(participant)
            }
            else {
                tempParticipants.append(Payment.Participant(memberId: m.id, advanceAmount: 0, seperateAmount: 0, memo: ""))
            }
        }
        
        participants = tempParticipants
        payment?.participants = participants
        members = tempMembers
    }
    
    func personalPrice() {
        if let idx = participants.firstIndex(where: { p in
            p.memberId == selectedMember.id
        }) {
            participants[idx].advanceAmount = Int(advanceAmountString) ?? 0
            participants[idx].seperateAmount = Int(seperateAmountString) ?? 0
        }
        howManySeperate()
        isShowingPersonalMemberSheet = false
    }
    
    func getPersonalPrice(idx: Int) -> Int {
        if participants[idx].seperateAmount != 0 {
            return participants[idx].seperateAmount - participants[idx].advanceAmount
        }
        else {
            let numOfDutch = participants.count - seperate[0]
            var amountOfDutch = 0
            if mode == .add {
                if priceString != "" {
                    amountOfDutch = Int(priceString)! - seperate[1]
                }
                else {
                    amountOfDutch = 0 - seperate[1]
                }
            }
            else if mode == .edit {
                if let p = payment {
                    amountOfDutch = p.payment - seperate[1]
                }
            }
            
            return amountOfDutch / numOfDutch - participants[idx].advanceAmount
        }
    }
    
    func howManySeperate() {
        var result = 0
        var amount = 0
        
        for participant in self.participants {
            if participant.seperateAmount != 0 {
                result += 1
                amount += participant.seperateAmount
            }
        }
        
        seperate[0] = result
        seperate[1] = amount
    }
}


#Preview {
    PaymentMemberManagementView(priceString: .constant("15000"), travelCalculation: .constant(TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: [])), members: .constant([TravelCalculation.Member(name: "김유진", advancePayment: 0, payment: 0)]), payment: .constant(nil), selectedMember: .constant(TravelCalculation.Member(name: "", advancePayment: 0, payment: 0)), participants: .constant([]), isShowingMemberSheet: .constant(false))
        .background(Color.black)
}
