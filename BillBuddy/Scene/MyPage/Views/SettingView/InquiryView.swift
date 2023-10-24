//
//  InquiryView.swift
//  BillBuddy
//
//  Created by 박지현 on 10/24/23.
//

import SwiftUI

struct InquiryView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack{
            Color.gray050
            VStack {
                Spacer().frame(height: 8)
                Group {
                    HStack {
                        Text("이메일")
                            .font(.body02)
                        Spacer()
                        Text("muumuu.j37@gmail.com")
                            .multilineTextAlignment(.trailing)
                            .font(.body04)
                            .foregroundColor(Color.gray600)
                    }
                }
                .padding(16)
                .frame(width: 361, height: 52)
                .background(.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray100, lineWidth: 1)
                )
                .padding(.top, 16)
                Spacer()
            }
        }
        .navigationTitle("문의 하기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image("arrow_back")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.systemBlack)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        InquiryView()
    }
}
