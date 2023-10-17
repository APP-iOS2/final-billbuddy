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
    
    @State private var isShowingMemberSheet: Bool = false
    @State private var tempMembers: [TravelCalculation.Member] = []
    
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
        Section {
            DatePicker(selection: $paymentDate, in: travelCalculation.startDate.toDate()...travelCalculation.endDate.toDate(), displayedComponents: .date, label: {
                Text("날짜")
                    .font(.custom("Pretendard-Bold", size: 14))
            })
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
        .padding(.top, 16)
        .padding(.trailing, 16)
    }
    var typePickerSection: some View {
        VStack {
            
            HStack{
                Text("분류")
                    .font(.custom("Pretendard-Bold", size: 14))
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
                    .font(.custom("Pretendard-Bold", size: 14))
                TextField("내용을 입력해주세요", text: $expandDetails)
                    .multilineTextAlignment(.trailing)
                    .font(.custom("Pretendard-Medium", size: 14))
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
                .font(.custom("Pretendard-Bold", size: 14))
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
                            .font(.custom("Pretendard-Medium", size: 14))
                            .foregroundStyle(Color.gray500)
                        
                        Image("chevron_right")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.gray500)
                    }
                    else {
                        Text("수정하기")
                            .font(.custom("Pretendard-Medium", size: 14))
                            .foregroundStyle(.black)
                        
                        Image("chevron_right")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.black)
                    }
                }
                .padding(.top, 14)
                .padding(.trailing, 16)
                .padding(.bottom, 15)
            })
            
        }
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
            ScrollView {
                ForEach(travelCalculation.members) { member in
                    HStack {
                        if tempMembers.firstIndex(where: { m in
                            m.name == member.name
                        }) != nil {
                            /// 해당 멤버가 없는 경우
                            Image("form-checked-input radio")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        else {
                            /// 해당 멤버가 있는 경우
                            Image("form-check-input radio")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        
                        Text(member.name)
                            .font(.custom("Pretendard-Semibold", size: 14))
                            .foregroundStyle(Color.black)
                        
                        Spacer()
                    }
                    .padding(.leading, 32)
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
                .presentationDetents([.fraction(0.4)])
            }
            .padding(.top, 8)
            .padding(.bottom, 36)
            Button(action: {
                isShowingMemberSheet = false
                members = tempMembers
            }, label: {
                HStack {
                    Spacer()
                    Text("인원 추가")
                        .font(.custom("Pretendard-Bold", size: 14))
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
            ScrollView {
                ForEach(travelCalculation.members) { member in
                    HStack {
                        if tempMembers.firstIndex(where: { m in
                            m.name == member.name
                        }) != nil {
                            Image("form-checked-input radio")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        else {
                            Image("form-check-input radio")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        
                        Text(member.name)
                            .font(.custom("Pretendard-Semibold", size: 14))
                            .foregroundStyle(Color.black)
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
                        Spacer()
                    }
                    .padding(.leading, 32)
                    .padding(.top, 36)
                    .onAppear {
                        tempMembers = members
                    }
                }
                .presentationDetents([.fraction(0.4)])
            }
            .padding(.top, 8)
            .padding(.bottom, 36)
            
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
                        .font(.custom("Pretendard-Bold", size: 14))
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
                    .font(.custom("Pretendard-Medium", size: 14))
                    .padding(.leading, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 12)
                Spacer()
                Text("0원")
                    .font(.custom("Pretendard-Medium", size: 14))
                    .foregroundStyle(Color.gray600)
                    .padding(.trailing, 16)
            }
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray050)
            }
            .padding(.leading, 15)
            .listRowSeparator(.hidden)
        }
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
                    .font(.custom("Pretendard-Bold", size: 14))
                Spacer()
                
                TextField("결제금액을 입력해주세요", text: $priceString)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .font(.custom("Pretendard-Medium", size: 14))
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

//#Preview {
//    SubPaymentView(userTravel: UserTravel(travelId: "", travelName: "신나는 유럽 여행", startDate: 0, endDate: 0), expandDetails: .constant(""), priceString: .constant(""), headCountString: .constant(""), selectedCategory: .constant(.accommodation), category: .constant(""), paymentDate: .constant(Date()), isSelectedCategory: false, isVisibleCategorySelectPicker: false)
//}