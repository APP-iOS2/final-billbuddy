//
//  AddPaymentMemberView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/4/23.
//

import SwiftUI

struct AddPaymentMemberView: View {
    @Binding var newMembers: [TravelCalculation.Member]
    @Binding var travelCalculation: TravelCalculation
    
    @State private var isShowingAddSheet: Bool = false
    @State private var tempMembers: [TravelCalculation.Member] = []
    
    var body: some View {
        Section {
            HStack {
                Text("인원")
                    .font(.custom("Pretendard-Bold", size: 14))
                    .padding(.top, 16)
                    .padding(.leading, 16)
                    .padding(.bottom, 17)
                Spacer()
                Button(action: {
                    isShowingAddSheet = true
                }, label: {
                    HStack (spacing: 0) {
                        if newMembers.count == 0 {
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
            .sheet(isPresented: $isShowingAddSheet, content: {
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
                        tempMembers = newMembers
                    }
                    .presentationDetents([.fraction(0.4)])
                }
                .padding(.top, 8)
                .padding(.bottom, 36)
                
                Button(action: {
                    isShowingAddSheet = false
                    newMembers = tempMembers
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
                
            })
            
            ForEach(newMembers) { member in
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
    }
}

