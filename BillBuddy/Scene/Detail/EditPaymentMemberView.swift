//
//  EditPaymentMemberView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/4/23.
//

import SwiftUI

struct EditPaymentMemberView: View {
    @Binding var payment: Payment
    @ObservedObject var memberStore: MemberStore
    
    @State private var isShowingAddSheet: Bool = false
    @State private var tempMembers: [Member] = []
    
    var body: some View {
        Section {
            HStack {
                Text("인원")
                    .bold()
                Spacer()
                Button(action: {
                    isShowingAddSheet = true
                }, label: {
                    if payment.participants.count == 0 {
                        Text("추가하기")
                    }
                    else {
                        Text("수정하기")
                    }
                })
                
            }
            .padding()
//            .sheet(isPresented: $isShowingAddSheet, content: {
//                List(memberStore.members) { member in
//                    HStack {
//                        if tempMembers.firstIndex(where: { m in
//                            m.name == member.name
//                        }) != nil {
//                            Image(systemName: "checkmark.seal.fill")
//                        }
//                        else {
//                            Image(systemName: "checkmark.seal")
//                        }
//                        
//                        Text(member.name)
//                            .onTapGesture {
//                                // TODO: firstIndex로 두번이나 찾으면 메모리 너무 많이 먹는거 아닌가
//                                // 각각에 대해서 배열로 만들수도 없고 이걸 어뚜케 해야하지? 나중에 Refactoring 고민해보기!
//                                if let existMember = tempMembers.firstIndex(where: { m in
//                                    m.name == member.name
//                                }) {
//                                    tempMembers.remove(at: existMember)
//                                }
//                                else {
//                                    tempMembers.append(member)
//                                }
//                            }
//                        Spacer()
//                        
//                        
//                    }
//                }
//                .onAppear {
//                    memberStore.fetchAll()
//                    //participant.memberId -> member 찾아서 tempMembers 에 넣어주기
////                    tempMembers = memberStore.findMembersByParticipants(participants: payment.participants)
//                }
//                .presentationDetents([.fraction(0.4)])
//                
//                Button(action: {
//                    isShowingAddSheet = false
////                    newMembers = payment.participants
//                }, label: {
//                    HStack {
//                        Spacer()
//                        Text("추가하기")
//                            .bold()
//                        Spacer()
//                    }
//                    .padding()
//                })
//            })
            
            
//            ForEach(memberStore.findMembersByParticipants(participants: payment.participants)) { member in
//                Text(member.name)
//            }
            
            ForEach(payment.participants, id:\.self) { participant in
                Text(participant.memberId)
            }
            
        }
    }
}

