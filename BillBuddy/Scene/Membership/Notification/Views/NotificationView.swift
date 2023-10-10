//
//  NotificationView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        ScrollView {
            ForEach(0..<10) { _ in
                ChatNotifincationCell()
                Divider()
            }
        }
        .navigationBarTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NotificationView()
}
