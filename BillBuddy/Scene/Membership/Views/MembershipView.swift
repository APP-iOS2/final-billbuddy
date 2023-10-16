//
//  MembershipView.swift
//  BillBuddy
//
//  Created by SIKim on 10/12/23.
//

import SwiftUI

struct MembershipView: View {
    @State private var isShowingFullScreen: Bool = false
    
    var body: some View {
        VStack {
            Button("구독 결제") {
                isShowingFullScreen = true
            }
            .fullScreenCover(isPresented: $isShowingFullScreen, content: {
                TossPaymentsView(isShowingFullScreen: $isShowingFullScreen)
            })
        }
    }
}

#Preview {
    NavigationStack {
        MembershipView()
    }
}
