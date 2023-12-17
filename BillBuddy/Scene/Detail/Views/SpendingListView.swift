//
//  SpendingListView.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/27.
//

import SwiftUI

struct SpendingListView: View {
    var body: some View {
        List {
            Section {
                Text("전체 총 지출")
            }
            Section {
                Text("오늘의 총 지출")
            }
            Section {
                Text("교통 총 지출")
            }
            Section {
                Text("숙박 총 지출")
            }
            Section {
                Text("관광 총 지출")
            }
            Section {
                Text("식비 총 지출")
            }
            Section {
                Text("기타 총 지출")
            }
            Section {
                Text("인원별 정산")
            }
        }
    }
}

#Preview {
    SpendingListView()
}
