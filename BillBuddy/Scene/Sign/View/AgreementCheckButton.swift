//
//  AgreementCheckButton.swift
//  BillBuddy
//
//  Created by 박지현 on 10/17/23.
//

import SwiftUI

struct AgreementCheckButton: View {
    @Binding var agreement: Bool
    var text: String

    var body: some View {
        HStack {
            Button(action: {
                agreement.toggle()
            }, label: {
                HStack {
                    Image(systemName: agreement ? "checkmark.square.fill" : "checkmark.square")
                        .resizable()
                        .foregroundColor(.gray300)
                        .frame(width: 24, height: 24)
                    Text(text)
                }
            }).buttonStyle(.plain)
                .font(.body04)
                .frame(height: 24)
            Spacer()
        }
    }
}


#Preview {
    AgreementCheckButton(agreement: .constant(true), text: "동의합니다")
}
