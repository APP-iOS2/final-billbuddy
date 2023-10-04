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
    
    var body: some View {
        Section {
            HStack {
                Text("인원")
                    .bold()
                Spacer()
                Button(action: {
                    isShowingAddSheet = true
                }, label: {
                    Text("수정하기")
                })
                
            }
            .padding()
            
            ForEach(payment.participants, id:\.self) { participant in
                Text(participant.memberId)
            }
        }
    }
}

