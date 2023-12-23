//
//  SubView.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/9/23.
//

import SwiftUI
import Kingfisher

struct MemberCell: View {
    @EnvironmentObject private var userTravelStore: UserTravelStore
    @ObservedObject var sampleMemeberStore: SampleMemeberStore
    @Binding var isShowingShareSheet: Bool
    var member: TravelCalculation.Member
    let isPaymentSettled: Bool
    
    var onEditing: () -> Void
    var onRemove: () -> Void
    let saveAction: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            if member.userImage != "" {
                KFImage(URL(string: member.userImage))
                    .placeholder {
                        ProgressView()
                            .frame(width: 40, height: 40)
                    }
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Image(.defaultUser)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            
            VStack(alignment: .leading, spacing: 0) {
                Text(member.name)
                    .font(.body04)
                    .frame(height: 20)
                Text(member.advancePayment.wonAndDecimal)
                    .font(.body02)
                    .frame(height: 20)
            }
            .padding(.leading, 12)
            .foregroundColor(Color.systemBlack)
            
            Spacer()
            if member.inviteState != .invited {
                Button(member.inviteState.string) {
                    if member.inviteState == .dummy {
                        sampleMemeberStore.selectMember(member.id)
                        isShowingShareSheet = true
                    }
                    if member.inviteState == .wating {
                        sampleMemeberStore.cancelInvite(member.id) {
                            saveAction()
                        }
                    }
                }
                .frame(width: 80, height: 28)
                .background(member.inviteState == .dummy ? Color.myPrimaryLight : Color.myGreenLight)
                .clipShape(RoundedRectangle(cornerRadius: 15.5))
                .font(Font.caption02)
                .foregroundStyle(member.inviteState == .dummy ? Color.myPrimary : Color.myGreen)
                .padding(.trailing, 12)
            }
                
                
        }
        .frame(height: 40)
        .padding([.top, .bottom], 12)
        .swipeActions(edge: .trailing) {
            if isPaymentSettled == false {
                Button("삭제") {
                    if isPaymentSettled == false {
                        onRemove()
                        saveAction()
                    }
                }
                .tint(Color.error)
                
                if member.inviteState != .wating {
                    Button("수정") {
                        if isPaymentSettled == false {
                            onEditing()
                            saveAction()
                        }
                    }
                    .tint(Color.gray500)
                }
            }
        }
    }
}

#Preview {
    MemberCell(sampleMemeberStore: SampleMemeberStore(), isShowingShareSheet: .constant(false), member: TravelCalculation.Member(name: "name", advancePayment: 100, payment: 100), isPaymentSettled: false, onEditing: { print("edit") }, onRemove: { print("remove") }, saveAction: { })
}
