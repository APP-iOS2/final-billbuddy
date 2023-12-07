//
//  DeepLinkView.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/18/23.
//

import SwiftUI

struct LodingView: View {
    @EnvironmentObject private var invitTravelService: InvitTravelService
    @EnvironmentObject private var tabViewStore: TabViewStore
    @EnvironmentObject private var userTravelStore: UserTravelStore

    var body: some View {
        VStack {
            Rectangle()
                .overlay(alignment: .center) {
                    Image(.billBuddy)
                }
                .foregroundStyle(Color.myPrimary)
                .ignoresSafeArea(.all)
        }
        .onAppear {
            tabViewStore.popToRoow()
            invitTravelService.joinAndFetchTravel { travel in
                userTravelStore.fetchTravelCalculation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                    tabViewStore.pushView(type: .travel, travel: travel)
                })
            }
        }
    }
}

#Preview {
    LodingView()
        .environmentObject(InvitTravelService.shared)
        .environmentObject(TabViewStore())
        .environmentObject(UserTravelStore())
}
