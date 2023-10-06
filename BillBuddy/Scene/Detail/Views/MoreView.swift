//
//  MoreView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/4/23.
//

import SwiftUI

struct MoreView: View {
    let viewNames: [String] = ["채팅(유리님)", "지도(승준님)", "날짜 관리(아리님?)", "인원 관리(지호님)", "결산(지호님)"]

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
