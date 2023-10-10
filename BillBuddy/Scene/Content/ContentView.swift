//
//  ContentView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var schemeServie: SchemeService = .shared
    @StateObject private var userTravelStore = UserTravelStore()
    @StateObject private var settlementExpensesStore = SettlementExpensesStore()
    
    
    var body: some View {
        VStack {
            if schemeServie.url == nil {
                BillBuddyTabView()
                    .environmentObject(settlementExpensesStore)
                    .environmentObject(userTravelStore)
            } else {
                BillBuddyTabView()
                    .environmentObject(settlementExpensesStore)
                    .environmentObject(userTravelStore)

            }
        }
    }
}

#Preview {
    ContentView()
}
