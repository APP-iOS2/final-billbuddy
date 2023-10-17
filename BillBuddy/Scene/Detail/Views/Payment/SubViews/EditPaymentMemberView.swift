//
//  EditPaymentMemberView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/4/23.
//

import SwiftUI

struct EditPaymentMemberView: View {
    @Binding var payment: Payment
    @Binding var travelCalculation: TravelCalculation
    
    @State private var isShowingEditSheet: Bool = false
    @State private var tempMembers: [TravelCalculation.Member] = []
    @State private var existingMembers: [TravelCalculation.Member] = []
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("인원")
                    .font(.custom("Pretendard-Bold", size: 14))
                    .padding(.top, 16)
                    .padding(.leading, 16)
                    .padding(.bottom, 17)
                Spacer()
                Button(action: {
                    isShowingEditSheet = true
                }, label: {
                    HStack(spacing: 0){
                        if payment.participants.isEmpty {
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
            
            .sheet(isPresented: $isShowingEditSheet, content: {
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
                            tempMembers = existingMembers
                        }
                    }
                    .presentationDetents([.fraction(0.4)])
                }
                .padding(.top, 8)
                .padding(.bottom, 36)
                
                Button(action: {
                    isShowingEditSheet = false
                    var participants: [Payment.Participant] = []
                    
                    for m in tempMembers {
                        participants.append(Payment.Participant(memberId: m.id , payment: m.payment))
                    }
                    payment.participants = participants
                    existingMembers = tempMembers
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
            })
            
            ForEach(existingMembers) { member in
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
        .onAppear {
            for participant in payment.participants {
                if let existMember = travelCalculation.members.firstIndex(where: { m in
                    m.id == participant.memberId
                }) {
                    if let _ = existingMembers.firstIndex(of: travelCalculation.members[existMember]) {
                        continue
                    }
                    existingMembers.append(travelCalculation.members[existMember])
                }
            }
        }
    }
}

