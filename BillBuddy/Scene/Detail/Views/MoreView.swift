//
//  MoreView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/4/23.
//

import SwiftUI

struct MoreView: View {
    @Binding var travelCalculation: TravelCalculation
    let viewNames: [String] = ["채팅(유리님)", "지도(승준님)", "방 수정(아리님)", "인원 관리(지호님)", "결산(지호님)"]

    var body: some View {
        VStack {
            List(viewNames, id:\.self) { name in
                NavigationLink {
                    Text(name)
                } label: {
                    Text(name)
                }
            }
            
            NavigationLink {
                
            } label: {
                Text("인원관리")
            }

        }
    }
}

#Preview {
    MoreView(travelCalculation: .constant(TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: Date().timeIntervalSince1970, endDate: Date().timeIntervalSince1970, updateContentDate: Date().timeIntervalSince1970, members: [])))
}
