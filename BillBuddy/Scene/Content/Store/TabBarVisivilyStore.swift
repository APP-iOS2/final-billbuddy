//
//  TabBarVisivilyStore.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/19/23.
//

import SwiftUI

final class TabBarVisivilyStore: ObservableObject {
    @Published var visivility: Visibility = .visible
    
    func hideTabBar() {
        visivility = .hidden
    }
    
    func showTabBar() {
        visivility = .visible
    }
    
}
