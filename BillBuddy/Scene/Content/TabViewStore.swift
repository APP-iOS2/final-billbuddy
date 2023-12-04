//
//  TabViewStore.swift
//  BillBuddy
//
//  Created by 윤지호 on 11/18/23.
//

import Foundation

final class TabViewStore: ObservableObject {
    @Published var selectedTab: Int = 0 {
        didSet {
            switchTab()
        }
    }
    
    @Published var isPresentedDetail: Bool = false
    @Published var isPresentedChat: Bool = false
    @Published var isPresnetedNoti: Bool = false
    
    var seletedTravel: TravelCalculation = TravelCalculation.sampletravel
    
    private func switchTab() {
        DispatchQueue.main.async {
            self.isPresentedDetail = false
            self.isPresentedChat = false
            self.isPresnetedNoti = false
        }
    }
    
    @MainActor
    func pushView(type: NotiType, travel: TravelCalculation? = nil) {
        if let travel {
            seletedTravel = travel
        }
        switch type {
        case .travel, .invite:
            selectedTab = 0
            isPresentedDetail = true
        case .chatting:
            selectedTab = 1
            isPresentedChat = true
        case .notice:
            selectedTab = 2
            isPresnetedNoti = true
        }
    }
    
    @MainActor
    func poToRoow() {
        isPresentedDetail = false
        isPresentedChat = false
        isPresnetedNoti = false
    }
}

