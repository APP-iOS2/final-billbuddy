//
//  RandomPasswordAlertView.swift
//  BillBuddy
//
//  Created by SIKim on 12/15/23.
//

import SwiftUI

struct MessageAlertView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    let firstLineMessage: String
    let secondLineMessage: String
    let isDismiss: Bool
    let action: () -> Void
    
    var body: some View {
        VStack {
            Group {
                Text(firstLineMessage)
                    .padding(.top, 46)
                    .multilineTextAlignment(.center)
                Text(secondLineMessage)
            }
            .font(.body04)
            
            Spacer()
            
            Button(action: {
                action()
                isPresented.toggle()
                isDismiss ? dismiss() : ()
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
    func messageAlert(isPresented: Binding<Bool>, firstLineMessage: String, secondLineMessage: String, isDismiss: Bool, action: @escaping () -> Void) -> some View {
        return modifier(MessageAlertModifier(isPresented: isPresented, firstLineMessage: firstLineMessage, secondLineMessage: secondLineMessage, isDismiss: isDismiss, action: action))
    }
}

struct MessageAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let firstLineMessage: String
    let secondLineMessage: String
    let isDismiss: Bool
    let action: () -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            content
            ZStack {
                if isPresented {
                    Rectangle()
                        .fill(.black.opacity(0.5))
                        .blur(radius: isPresented ? 2 : 0)
                        .ignoresSafeArea()
                    MessageAlertView(isPresented: self.$isPresented, firstLineMessage: self.firstLineMessage, secondLineMessage: self.secondLineMessage, isDismiss: self.isDismiss, action: self.action)
                        .transition(.asymmetric(insertion: .scale(scale: 1.1).animation(.spring(response: 0.2)), removal: .opacity.animation(.spring(response: 0.2))))
                }
            }
        }
    }
}

#Preview {
    MessageAlertView(isPresented: .constant(true), firstLineMessage: "sikim4991@gmail.com로 메일이 발송되었어요.", secondLineMessage: "메일에 기재된 링크를 클릭하여 변경해주세요.", isDismiss: false, action: {})
}
