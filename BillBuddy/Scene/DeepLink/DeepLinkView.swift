//
//  DeepLinkView.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/18/23.
//

import SwiftUI

struct DeepLinkView: View {
    @EnvironmentObject var schemeServie: SchemeService
    
    var body: some View {
        VStack {
            if schemeServie.isLoading {
                Rectangle()
                    .overlay(alignment: .center) {
                        Image(.billBuddy)
                    }
                    .foregroundStyle(Color.myPrimary)
                    .ignoresSafeArea(.all)
            } else {
                switch schemeServie.componentedUrl?.host {
                case .chatting:
                    ChattingRoomView(travel: schemeServie.travel)
                case .travel:
                    DetailMainView(paymentStore: PaymentStore(travel: schemeServie.travel), travelDetailStore: TravelDetailStore(travel: schemeServie.travel))
                case .notice:
                    Text("View - notice").onAppear { print("-> appear")}
                case .invite:
                    DetailMainView(paymentStore: PaymentStore(travel: schemeServie.travel), travelDetailStore: TravelDetailStore(travel: schemeServie.travel))
                case nil:
                    Text("View - nil").onAppear { print("-> appear")}
                }
               
            }
        }
        .onAppear {
            if schemeServie.componentedUrl != nil {
                schemeServie.joinAndFetchTravel()
            }
        }
    }
}

#Preview {
    DeepLinkView()
        .environmentObject(SchemeService.shared)
}
