//
//  Member.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import Foundation
import FirebaseFirestoreSwift

struct TravelDate {
    @DocumentID var id: String?
    var travelDate: Double
    
    var formattedDate: String {
        let dateCreatedAt: Date = Date(timeIntervalSince1970: travelDate)
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "MM/dd HH시 mm분"
        
        return dateFormatter.string(from: dateCreatedAt)
    }
}
