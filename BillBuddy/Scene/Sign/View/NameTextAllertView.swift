//
//  NameTextAllertView.swift
//  BillBuddy
//
//  Created by 박지현 on 12/17/23.
//

import SwiftUI

struct NameTextAllertView: View {
    @Binding var isPresented: Bool
    @ObservedObject var signUpStore: SignUpStore
    
    var body: some View {
        VStack {
            TextField("이름을 입력해주세요.", text: $signUpStore.signUpData.name)
                .padding(16)
                .background(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray300, lineWidth: 1))
                .font(.body04)
                .padding(.bottom, 20)
            
            Button(action: {
                isPresented.toggle()
            }, label: {
                Text("확인")
                    .font(.body02)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.myPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            })
            .padding(.bottom, 14)
            
        }
        .padding(20)
        .frame(width: 300, height: 245)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NameTextAllertView(isPresented: .constant(true), signUpStore: SignUpStore())
}
