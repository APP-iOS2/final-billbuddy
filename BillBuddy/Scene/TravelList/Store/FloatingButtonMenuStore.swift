//
//  FloatingButtonMenuStore.swift
//  BillBuddy
//
//  Created by Ari on 10/18/23.
//

import SwiftUI

final class FloatingButtonMenuStore: ObservableObject {
    @Published var showMenuItem1 = false
    @Published var showMenuItem2 = false
    @Published var isDimmedBackground = false
    @Published var buttonImage = "openButton"
    
//    func showMenu() {
//        showMenuItem1 = !showMenuItem1
//        showMenuItem2 = !showMenuItem2
//        buttonImage = showMenuItem1 || showMenuItem2 ? "closeButton" : "openButton"
//    }
//    
//    func closeMenu() {
//        showMenuItem1 = false
//        showMenuItem2 = false
//        buttonImage = "openButton"
//    }
    
    func showMenu() {
            if showMenuItem1 || showMenuItem2 {
                showMenuItem1 = false
                showMenuItem2 = false
                buttonImage = "openButton"
                isDimmedBackground = false
            } else {
                withAnimation(.bouncy) {
                    showMenuItem1 = true
                    showMenuItem2 = true
                }
                buttonImage = "closeButton"
                isDimmedBackground = true
            }
        }
    
        func closeMenu() {
            showMenuItem1 = false
            showMenuItem2 = false
            isDimmedBackground = false
            buttonImage = "openButton"
        }
}
