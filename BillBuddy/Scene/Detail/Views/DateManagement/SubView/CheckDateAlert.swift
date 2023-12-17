//
//  CustomEditDateAlert.swift
//  BillBuddy
//
//  Created by 윤지호 on 12/17/23.
//

import SwiftUI

extension View {
    func checkDateAlert(
        isPresented: Binding<Bool>
    ) -> some View {
        return CheckDateAlert(isPresented: isPresented)
    }
}

struct CheckDateModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Rectangle()
                    .fill(.black.opacity(0.7))
                    .ignoresSafeArea()
                    .onTapGesture {
                        self.isPresented = false
                    }
                
                CheckDateAlert(
                    isPresented: self.$isPresented
                )
                .transition(.opacity)
            }
        }
        .animation(
            isPresented ? .snappy(duration: 4, extraBounce: 0.9) : .none,
            value: isPresented
        )
    }
}

struct CheckDateAlert: View {
    @Binding var isPresented: Bool
    let text: String =
"""
📢 수정한 날짜 외에 다른 날짜에 지출내역이
있어 수정할 수 없어요

📢 날짜를 변경하고 싶다면, 지출내역을 수정하고 변경해주세요!
"""
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .frame(width: 301, height: 192)
            .foregroundStyle(Color.gray200)
            .overlay(alignment: .top) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer()
                        Button {
                            isPresented = false
                        } label: {
                            Image(.close)
                                .resizable()
                        }
                        .frame(width: 24, height: 24)
                        .padding([.top, .trailing], 20)
                    }
                    .padding(.bottom, 17)
                    VStack(alignment: .leading ,spacing: 0) {
                        Text(text)
                            .font(.body04)
                    }
                    .padding(.horizontal, 24)
                }
            }
    }
}

#Preview {
    Text("Spending Alert")
        .modifier(
            CheckDateModifier(isPresented: .constant(true))
        )
}
