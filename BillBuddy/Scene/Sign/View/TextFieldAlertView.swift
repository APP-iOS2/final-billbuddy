//
//  NameTextAllertView.swift
//  BillBuddy
//
//  Created by 박지현 on 12/17/23.
//

import SwiftUI

struct TextFieldAlertView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    @ObservedObject var signUpStore: SignUpStore
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Group {
                Text("이름을 입력 해주세요.")
                    .multilineTextAlignment(.center)
                
                TextField("이름", text: $signUpStore.signUpData.name)
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray300, lineWidth: 1))
                    .padding(.bottom, 8)
            }
            .padding(.bottom, 12)
            .font(.body04)
            
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
    TextFieldAlertView(isPresented: .constant(true), signUpStore: SignUpStore())
}
