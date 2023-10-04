//
//  Place.swift
//  BillBuddy
//
//  Created by 이승준 on 10/4/23.
//

import Foundation

public struct Place: Identifiable, Codable {
    public var id: UUID = UUID()
    public var placeName: String
}
