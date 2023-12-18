//
//  TextFieldAlert.swift
//  BillBuddy
//
//  Created by 박지현 on 12/18/23.
//

import SwiftUI

struct TextFieldAlert: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    @Binding var textField: String
    let message: String
    let isDismiss: Bool
    let action: () -> Void
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Group {
                Text(message)
                    .multilineTextAlignment(.center)
                
                TextField("", text: $textField )
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
    func textFieldAlert(isPresented: Binding<Bool>, textField: Binding<String>, message: String, isDismiss: Bool, action: @escaping () -> Void) -> some View {
        return modifier(TextAlertModifier(isPresented: isPresented, textField: textField, message: message, isDismiss: isDismiss, action: action))
    }
}

struct TextAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var textField: String
    let message: String
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
                    TextFieldAlert(isPresented: self.$isPresented, textField: self.$textField, message: self.message, isDismiss: self.isDismiss, action: self.action)
                        .transition(.asymmetric(insertion: .scale(scale: 1.1).animation(.spring(response: 0.2)), removal: .opacity.animation(.spring(response: 0.2))))
                }
            }
        }
    }
}



#Preview {
    TextFieldAlert(isPresented: .constant(true), textField: .constant(""), message: "", isDismiss: false, action: {})
}
