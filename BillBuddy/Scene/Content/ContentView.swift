//
//  ContentView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var schemeServie: SchemeService = SchemeService()
    @StateObject private var userTravelStore = UserTravelStore()
  
    
    var body: some View {
        VStack {
            if schemeServie.url == nil {
                BillBuddyTabView()
            } else {
                NavigationStack {
                    TravelListView()
                        .environmentObject(userTravelStore)
                        .environmentObject(schemeServie)
                        .onOpenURL(perform: { url in
                            schemeServie.getUrl(url: url)
                        })
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SchemeService())
}
