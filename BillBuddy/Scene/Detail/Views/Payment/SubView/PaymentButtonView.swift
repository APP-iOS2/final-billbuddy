//
//  PaymentButtonView.swift
//  BillBuddy
//
//  Created by 김유진 on 12/19/23.
//

import SwiftUI

struct PaymentButtonView: View {
    @State var scale: Scale
    @State var text: String
    var body: some View {
        switch(scale) {
        case .big:
            HStack {
                Spacer()
                
                Text(text)
                    .font(.title05)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.top, 24)
            .padding(.bottom, 24)
            .background(Color.myPrimary)
            
        case .small:
            Text(text)
                .font(.title05)
                .foregroundColor(.white)
        }
    }
}

extension PaymentButtonView {
    enum Scale {
        case big
        case small
    }
}

#Preview {
    PaymentButtonView(scale: .big, text: "추가하기")
}
