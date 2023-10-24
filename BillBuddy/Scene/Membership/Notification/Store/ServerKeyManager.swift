//
//  ServerKeyManager.swift
//  BillBuddy
//
//  Created by hj on 2023/10/24.
//

import Foundation

class ServerKeyManager {
    static func loadServerKey() -> String? {
        if let path = Bundle.main.path(forResource: "ServerKeys", ofType: "plist"),
           let serverKeys = NSDictionary(contentsOfFile: path) as? [String: Any],
           let serverKey = serverKeys["ServerKey"] as? String {
            return serverKey
        }
        return nil
    }
}
