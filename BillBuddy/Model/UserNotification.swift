//
//  Notification.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/20/23.
//

import Foundation
import FirebaseFirestoreSwift

struct UserNotification: Identifiable, Codable {
    @DocumentID var id: String?
    var type: NotiType

    var content: String
    var contentId: String
    var addDate: Date
    var isChecked: Bool = false
}

enum NotiType: String, Codable {
    case chatting
    case travel
    case notice
    case invite
}
