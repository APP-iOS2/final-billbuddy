//
//  PaymentMemberManagementView.swift
//  BillBuddy
//
//  Created by 김유진 on 12/5/23.
//

import SwiftUI

struct PaymentMemberManagementView: View {
    @State var mode: Mode = .add
    
    @Binding var priceString: String
    @Binding var travelCalculation: TravelCalculation
    @Binding var members: [TravelCalculation.Member]
    @Binding var payment: Payment?
    @Binding var selectedMember: TravelCalculation.Member
    @Binding var participants: [Payment.Participant]
    
    @State private var isShowingMemberSheet: Bool = false
    @State private var isShowingDescription: Bool = false
    @State private var isShowingPersonalMemberSheet: Bool = false
    @State private var paidButton: Bool = false
    @State private var personalButton: Bool = false
    @State private var tempMembers: [TravelCalculation.Member] = []
    
    @State private var advanceAmountString: String = ""
    @State private var seperateAmountString: String = ""
    @State private var personalMemo: String = ""
    
    private var expectPrice: Int {
        let price: Int = Int(priceString) ?? 0
        let count: Int = participants.count
        
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
                participants = []
                for member in tempMembers {
                    participants.append(Payment.Participant(memberId: member.id, advanceAmount: 0, seperateAmount: (Int(priceString) ?? 0) / tempMembers.count, memo: ""))
                }
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
                participants = payment.participants
            }
        }
    }
    var editPaymentMemberSheet: some View {
        VStack {
            memberSheet
            
            Button(action: {
                isShowingMemberSheet = false
                
                participants = []
                for m in tempMembers {
                    participants.append(Payment.Participant(memberId: m.id, advanceAmount: 0, seperateAmount: 0, memo: ""))
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
                print(participants)
            }, label: {
                HStack(spacing: 2) {
                    Text(member.name)
                        .font(.body04)
                        .padding(.leading, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 12)
                    Spacer()
                    // MARK: 가격
                    if let idx = participants.firstIndex(where: { p in
                        p.memberId == member.id
                    }) {
                        Text("₩\(participants[idx].seperateAmount - participants[idx].advanceAmount)")
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
                    addPersonalPriceSection
                        .onAppear(perform: {
                            if let idx = participants.firstIndex(where: { p in
                                p.memberId == selectedMember.id
                            }) {
                                advanceAmountString = String(participants[idx].advanceAmount)
                                seperateAmountString = String(participants[idx].seperateAmount)
                            }
                        })
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
                    
                    if paidButton {
                        TextField("금액을 입력해주세요", text: $advanceAmountString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .font(.body04)
                            .padding(.trailing, 14)
                    }
                    else if personalButton {
                        TextField("금액을 입력해주세요", text: $seperateAmountString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .font(.body04)
                            .padding(.trailing, 14)
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
                isShowingPersonalMemberSheet = false
                if let idx = participants.firstIndex(where: { p in
                    p.memberId == selectedMember.id
                }) {
                    participants[idx].advanceAmount = Int(advanceAmountString) ?? 0
                    participants[idx].seperateAmount = Int(seperateAmountString) ?? 0
                }
                
                var sum = 0
                for participant in participants {
                    sum += participant.seperateAmount
                }
                priceString = String(sum)
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

#Preview {
    PaymentMemberManagementView(priceString: .constant("15000"), travelCalculation: .constant(TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: [])), members: .constant([TravelCalculation.Member(name: "김유진", advancePayment: 0, payment: 0)]), payment: .constant(nil), selectedMember: .constant(TravelCalculation.Member(name: "", advancePayment: 0, payment: 0)), participants: .constant([]))
}
