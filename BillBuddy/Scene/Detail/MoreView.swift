//
//  MoreView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/4/23.
//

import SwiftUI

struct MoreView: View {
    let viewNames: [String] = ["채팅", "지도", "날짜 관리", "인원 관리", "결산"]
    var body: some View {
        VStack {
            List(viewNames, id:\.self) { name in
                NavigationLink {
                    Text(name)
                } label: {
                    Text(name)
                }
            }
        }
    }
}

#Preview {
    MoreView()
}
