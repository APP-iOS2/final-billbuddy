//
//  RandomPasswordAlertView.swift
//  BillBuddy
//
//  Created by SIKim on 12/15/23.
//

import SwiftUI

struct RandomPasswordAlertView: View {
    @Binding var isPresented: Bool
    let firstLineMessage: String
    let secondLineMessage: String
    
    var body: some View {
        VStack {
            Group {
                Text(firstLineMessage)
                    .padding(.top, 46)
                Text(secondLineMessage)
            }
            .font(.body04)
            
            Spacer()
            
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

extension View {
    func randomPasswordAlert(isPresented: Binding<Bool>, firstLineMessage: String, secondLineMessage: String) -> some View {
        return modifier(RandomPasswordAlertmodifier(isPresented: isPresented, firstLineMessage: firstLineMessage, secondLineMessage: secondLineMessage))
    }
}

struct RandomPasswordAlertmodifier: ViewModifier {
    @Binding var isPresented: Bool
    let firstLineMessage: String
    let secondLineMessage: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            ZStack {
                if isPresented {
                    Rectangle()
                        .fill(.black.opacity(0.5))
                        .blur(radius: isPresented ? 2 : 0)
                        .ignoresSafeArea()
                    RandomPasswordAlertView(isPresented: self.$isPresented, firstLineMessage: self.firstLineMessage, secondLineMessage: self.secondLineMessage)
                        .transition(.asymmetric(insertion: .scale(scale: 1.1).animation(.spring(response: 0.2)), removal: .opacity.animation(.spring(response: 0.2))))
                }
            }
        }
    }
}

#Preview {
    RandomPasswordAlertView(isPresented: .constant(true), firstLineMessage: "임시 비밀번호가 발송되었어요.", secondLineMessage: "로그인 후 비밀번호를 꼭 변경해주세요.")
}
