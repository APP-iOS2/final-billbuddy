//
//  LicenseView.swift
//  BillBuddy
//
//  Created by 박지현 on 10/24/23.
//

import SwiftUI

struct LicenseView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack{
            Color.gray050
            VStack {
                Spacer().frame(height: 8)
                Group {
                    HStack {
                        Text("버전")
                            .font(.body02)
                        Spacer()
                        Text("ver 0.0.1")
                            .multilineTextAlignment(.trailing)
                            .font(.body04)
                            .foregroundColor(Color.gray600)
                    }
                    .padding(16)
                    .frame(width: 361, height: 52)
                    
                    HStack {
                        Text("개발자")
                            .font(.body02)
                        Spacer()
                        VStack{
                            Text("윤지호 김상인 \n 김유진 노유리 \n 박지현 이승준 \n 한아리 황지연")
                        }
                            .multilineTextAlignment(.trailing)
                            .font(.body04)
                            .foregroundColor(Color.gray600)
                    }
                    .padding(16)
                    .frame(width: 361, height: 104)
                }
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
        .navigationTitle("오픈소스 라이센스")
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
        LicenseView()
    }
}
