//
//  ChatNotifincationCell.swift
//  BillBuddy
//
//  Created by hj on 2023/10/10.
//

import SwiftUI

struct ChatNotifincationCell: View {
    var body: some View {
        HStack(spacing: 25) {
            NavigationLink {
                
            } label: {
                knockNotificationLabel
            }
        }
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }
    
    private var knockNotificationLabel: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("\("UserName")")
                Text("Chatting Content")
            }
            
            Spacer()
            
            VStack {
                Spacer()
                Text("\("1") 시간 전")
            }
        }
    }
}

#Preview {
    ChatNotifincationCell()
}
