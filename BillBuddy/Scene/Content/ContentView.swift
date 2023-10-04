//
//  ContentView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var schemeServie: SchemeService
    
    var body: some View {
        VStack {
            NavigationStack {
                tempRoomListView()
            }
            
//            if schemeServie.url != nil {
//                NavigationStack {
//                    tempRoomListView()
//                }
//            } else {
//                TravelListView()
//            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SchemeService())
}
