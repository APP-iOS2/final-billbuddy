//
//  SchemeManager.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/27.
//

import SwiftUI

enum URLSchemeBase: String {
    case scheme = "billbuddybuddy"
    case path = "path"
    case query = "query"
}

class SchemeService: ObservableObject {
    @Published var url: URL? = nil
    
    var isEmptyUrl: Bool {
        return url == nil
    }
    
    func getUrl(url: URL) {
        self.url = url
        print("url -> \(url)")
    }
}
