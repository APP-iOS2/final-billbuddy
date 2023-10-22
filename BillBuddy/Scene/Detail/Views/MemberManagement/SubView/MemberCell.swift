//
//  SubView.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/9/23.
//

import SwiftUI

struct MemberCell: View {
    @ObservedObject var sampleMemeberStore: SampleMemeberStore
    @Binding var isShowingShareSheet: Bool
    var member: TravelCalculation.Member
    
    var onEditing: () -> Void
    var onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Image("DBPin")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.leading, 8)

            
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
                }
                .frame(width: 80, height: 28)
                .background(member.inviteState == .dummy ? Color.myPrimaryLight : Color.myGreenLight)
                .clipShape(RoundedRectangle(cornerRadius: 15.5))
                .font(Font.caption02)
                .foregroundStyle(member.inviteState == .dummy ? Color.myPrimary : Color.myGreen)
                .padding(.trailing, 12)
            }
        }
        
        .swipeActions(edge: .trailing) {
            Button("삭제") {
                onRemove()
            }
            .tint(Color.error)
            
            Button("수정") {
                onEditing()
            }
            .tint(Color.gray500)
            
        }
        .frame(height: 40)
        .padding([.top, .bottom], 12)
    }
}

#Preview {
    MemberCell(sampleMemeberStore: SampleMemeberStore(), isShowingShareSheet: .constant(false), member: TravelCalculation.Member(name: "name", advancePayment: 100, payment: 100), onEditing: { print("edit") }, onRemove: { print("remove") })
}
