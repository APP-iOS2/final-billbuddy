//
//  TravelFilter.swift
//  BillBuddy
//
//  Created by Ari on 2023/10/03.
//

import Foundation

enum TravelFilter: Int, CaseIterable {
    case paymentInProgress
    case paymentSettled
    
    var title: String {
        switch self {
        case .paymentInProgress: return "정산 중 여행"
        case .paymentSettled: return "정산 완료 여행"
        }
    }
}
