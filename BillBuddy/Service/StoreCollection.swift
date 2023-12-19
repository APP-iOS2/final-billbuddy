//
//  StoreCollection.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/3/23.
//

import Foundation

enum StoreCollection: String {
    case user
    case travel
    case payment
    case userTravel
    case notification
    
    var path: String {
        switch self {
        case .user:
            return "User"
        case .travel:
            return "TravelCalculation"
        case .payment:
            return "Payment"
        case .userTravel:
            return "UserTravel"
        case .notification:
            return "Notification"
        }
    }
}
