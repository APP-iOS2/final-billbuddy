//
//  MoreListCell.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/15/23.
//

import SwiftUI

struct MoreListCell: View {
    var item: ListItem
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(item.itemImageString)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(Color.gray900)
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 12)
                Text(item.itemName)
                    .font(Font.body04)
                    .foregroundStyle(Color.gray900)
                Spacer()
                Image("chevron_right")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(Color.gray700)
                    .frame(width: 24, height: 24)
            }
            .frame(height: 24)
            .padding([.leading, .trailing], 24)
            .padding([.top, .bottom], 16)
            Divider()
                .padding([.leading, .trailing], 16)
        }
    }
}

#Preview {
    MoreListCell(item: .chat)
}
