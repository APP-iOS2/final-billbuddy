//
//  TabViewStore.swift
//  BillBuddy
//
//  Created by 윤지호 on 11/18/23.
//

import Foundation

enum PushViewType {
    case travel
    case chatting
    case noti
}

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
    func pushView(type: PushViewType, travel: TravelCalculation? = nil) {
        if let travel {
            seletedTravel = travel
        }
        switch type {
        case .travel:
            isPresentedDetail = true
        case .chatting:
            isPresentedChat = true
        case .noti:
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

