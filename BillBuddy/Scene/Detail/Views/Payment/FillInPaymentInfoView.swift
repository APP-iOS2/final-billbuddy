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
    @State private var isShowingDatePickerSheet: Bool = false
    @State private var tempMembers: [TravelCalculation.Member] = []
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
    
    
    var body: some View {
        VStack(spacing: 16) {
            datePickerSection
            typePickerSection
            contentSection
            memberSelectSection
            priceSection
        }
    }
    
    var datePickerSection: some View {
        HStack {
            Text("날짜")
                .font(.body02)
                .padding(.leading, 16)
                .padding(.top, 16)
                .padding(.bottom, 20)
            Spacer()
            Button(action: {
                isShowingDatePickerSheet = true
            }, label: {
                HStack(spacing: 0) {
                    Text("\(paymentDate.dateSelectorFormat)")
                        .font(.body02)
                        .foregroundStyle(Color.gray600)
                    Image("chevron_right")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.gray500)
                }
                .padding(.trailing, 16)
            })
            
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        }
        .padding(.leading, 16)
        .padding(.top, 16)
        .padding(.trailing, 16)
        
        .sheet(isPresented: $isShowingDatePickerSheet, content: {
            VStack {
                DatePicker(selection: $paymentDate, in: travelCalculation.startDate.toDate()...travelCalculation.endDate.toDate(), label: {
                    Text("날짜")
                        .font(.body02)
                })
                
            }
            .focused(focusedField, equals: .date)
            .padding(.leading, 16)
            .padding(.top, 16)
            .padding(.bottom, 16)
            .padding(.trailing, 16)
            
            .presentationDetents([.fraction(0.3)])
            
        })
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
                    .focused(focusedField, equals: .type)
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
                isShowingMemberSheet = false
                members = tempMembers
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
            HStack {
                Text(member.name)
                    .font(.body04)
                    .padding(.leading, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 12)
                Spacer()
                Text("\(expectPrice)")
                    .font(.body04)
                    .foregroundStyle(Color.gray600)
                    .padding(.trailing, 16)
            }
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray050)
            }
            .padding(.leading, 15)
            .padding(.trailing, 14)
            //            .padding(.bottom, 8)
            .listRowSeparator(.hidden)
        }
        .padding(.bottom, 13)
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
                if !priceString.isEmpty {
                    Text("원")
                        .font(.body02)
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
