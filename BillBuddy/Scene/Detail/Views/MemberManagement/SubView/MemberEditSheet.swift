//
//  MemberEditSheet.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/15/23.
//

import SwiftUI

struct MemberEditSheet: View {
    @Binding var member: TravelCalculation.Member
    @Binding var isShowingEditSheet: Bool
    @State var isExcluded: Bool
    @State var nickName: String = ""
    @State var advancePayment: String = ""
    @FocusState private var isKeyboardUp: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.gray050, lineWidth: 1)
                .frame(width: 329, height: 52)
                .background(Color.gray100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay {
                    HStack {
                        Text("닉네임")
                            .font(.body02)
                        TextField(member.name, value: $nickName, formatter: NumberFormatter.numberFomatter)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .font(Font.body04)
                            .focused($isKeyboardUp)
                    }
                    .padding([.leading, .trailing], 16)
                }
                .padding(.top, 47)
                .padding(.bottom, 16)
            
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.gray050, lineWidth: 1)
                .frame(width: 329, height: 52)
                .background(Color.gray100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay {
                    HStack {
                        Text("선금")
                            .font(.body02)
                        TextField(member.advancePayment.wonAndDecimal, text: $advancePayment)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .font(Font.body04)
                            .focused($isKeyboardUp)
                    }
                    .padding([.leading, .trailing], 16)
                }
                .padding(.bottom, 16)

            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.gray050, lineWidth: 1)
                .frame(width: 329, height: 52)
                .background(Color.gray100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay {
                    HStack {
                        Text("지불 제외 여부")
                            .font(.body02)
                        Spacer()
                        Button {
                            isExcluded.toggle()
                            print(isExcluded)
                        } label: {
                            Image(isExcluded ? .checked : .noneChecked)
                        }
                    }
                    .padding([.leading, .trailing], 16)
                }
            Spacer()
            
            Button {
                member.isExcluded = isExcluded
                member.name = nickName
                member.advancePayment = Int(advancePayment) ?? 0
                isShowingEditSheet = false
            } label: {
                Text("수정 완료")
                    .font(Font.body02)
            }
            .frame(width: 332, height: 52)
            .background(Color.myPrimary)
            .cornerRadius(12)
            .foregroundColor(.white)
            .padding(.bottom, 54)
        }
        .onTapGesture {
            isKeyboardUp = false
        }
    }
}

#Preview {
    MemberEditSheet(member: .constant(TravelCalculation.Member(name: "name", advancePayment: 0, payment: 0)), isShowingEditSheet: .constant(true), isExcluded: false)
}
