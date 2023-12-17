//
//  StoreCollection.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/3/23.
//

import Foundation

enum StoreCollection: String {
    case user = "User"
    case travel = "TravelCalculation"
    case payment = "Payment"
    
    var path: String {
        return self.rawValue
    }
}
