//
//  MyPageStore.swift
//  BillBuddy
//
//  Created by 박지현 on 10/11/23.
//

import Foundation
import SwiftUI

final class MyPageStore: ObservableObject {
    @Published var myPageData = MyPageData()
}
