//
//  AddPaymentMemberView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/4/23.
//

import SwiftUI

struct AddPaymentMemberView: View {
    @Binding var newMembers: [Member]
    @ObservedObject var memberStore: MemberStore
    
    @State private var isShowingAddSheet: Bool = false
    
    var body: some View {
        Section {
            HStack {
                Text("인원")
                    .bold()
                Spacer()
                Button(action: {
                    isShowingAddSheet = true
                }, label: {
                    Text("추가하기")
                })
                
            }
            .padding()
            .sheet(isPresented: $isShowingAddSheet, content: {
                List(memberStore.members) { member in
                    HStack {
                        Text(member.name)
                            .onTapGesture {
                                // TODO: firstIndex로 두번이나 찾으면 메모리 너무 많이 먹는거 아닌가
                                // 각각에 대해서 배열로 만들수도 없고 이걸 어뚜케 해야하지? 나중에 Refactoring 고민해보기!
                                if let existMember = newMembers.firstIndex(where: { m in
                                    m.name == member.name
                                }) {
                                    newMembers.remove(at: existMember)
                                }
                                else {
                                    newMembers.append(member)
                                }
                            }
                        Spacer()
                        if let existMember = newMembers.firstIndex(where: { m in
                            m.name == member.name
                        }) {
                            Image(systemName: "checkmark.seal.fill")
                        }
                        
                    }
                }
                .onAppear {
                    memberStore.fetchAll()
                }
                .presentationDetents([.fraction(0.4)])
                
            })
            
            ForEach(newMembers) { member in
                Text(member.name)
                    .padding()
            }

        }
    }
}

